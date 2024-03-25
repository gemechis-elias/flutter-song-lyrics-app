import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/my_toast.dart';
import 'gallery_adapter.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  GalleryScreenState createState() => GalleryScreenState();
}

class GalleryScreenState extends State<GalleryScreen> {
  late DatabaseReference _databaseReference;
  List<Map<dynamic, dynamic>> items = [];
  List<Map<dynamic, dynamic>> images = [];

  void onItemClick(int index, String obj) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WallpaperFullScreenRoute(images: images, currentIndex: index),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    _databaseReference = FirebaseDatabase.instance.ref().child('gallery');

    _databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        dynamic value = snapshot.value;

        try {
          if (value is Map<dynamic, dynamic>) {
            List<Map<String, String>> newData = [];

            value.forEach((key, item) {
              if (item is Map<dynamic, dynamic> &&
                  item['id'] != null &&
                  item['image'] != null &&
                  item['date'] != null) {
                log('Processing item: $item');
                Map<String, String> imageData = {
                  'id': item['id'],
                  'image': item['image'],
                  'date': item['date'],
                };
                newData.add(imageData);
              }
            });

            setState(() {
              images = newData;
            });
          } else {
            print("Value is not in the expected Map<dynamic, dynamic> format.");
            print(value.toString());
          }
        } catch (e) {
          print("Error in fetchData: $e");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Our Gallery',
            style: TextStyle(
              fontFamily: 'Satisfy',
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: GalleryAdapter(images, onItemClick).getView(onItemClick),
    );
  }
}

class WallpaperFullScreenRoute extends StatefulWidget {
  final List<Map<dynamic, dynamic>> images;
  final int currentIndex;

  const WallpaperFullScreenRoute({
    super.key,
    required this.images,
    required this.currentIndex,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WallpaperFullScreenRouteState createState() =>
      _WallpaperFullScreenRouteState();
}

class _WallpaperFullScreenRouteState extends State<WallpaperFullScreenRoute> {
  late PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xff1f1f1f),
      body: GestureDetector(
        onTap: () {
          //Navigator.pop(context);
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Center(
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    imageUrl: widget.images[index]['image'],
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 24, // Adjust the size as needed
                        height: 24, // Adjust the size as needed
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                onPressed: () {
                  final String currentImage =
                      widget.images[currentIndex]['image'];
                  _save(currentImage);
                  // MyToast.show("Downloading...", context);
                  // show a toast or any other notification to indicate that the image is being downloaded
                  SnackBar snackBar = const SnackBar(
                    content: Text('Downloading...'),
                    duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(String imgPath) async {
    await _askPermission();
    var response = await Dio()
        .get(imgPath, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    log(result);
    // Show a toast or any other notification to indicate that the image is saved
    showNotification("Wallpaper is saved to Gallery");
    Navigator.pop(context);
  }

  Future<void> _askPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.request();
      if (status.isDenied) {
        // Permission denied.
        // Show a toast or any other notification to indicate that the permission is required to save the image.

        SnackBar snackBar = const SnackBar(
          content: Text('Please, Give a Permission...'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      var status = await Permission.storage.request();
      if (status.isDenied) {
        // Permission denied.
        // Show a toast or any other notification to indicate that the permission is required to save the image.

        SnackBar snackBar = const SnackBar(
          content: Text('Please, Give a Permission...'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showNotification(String message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'com.aastu.ecsf.aastu_ecsf',
      'Local Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloaded!',
      message,
      platformChannelSpecifics,
    );
  }
}
