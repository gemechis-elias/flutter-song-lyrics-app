import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadGallery extends StatefulWidget {
  const UploadGallery({Key? key}) : super(key: key);

  @override
  _UploadGalleryState createState() => _UploadGalleryState();
}

class _UploadGalleryState extends State<UploadGallery> {
  late DatabaseReference _databaseReference;
  List<Map<String, String>> images = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// ...

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

  Future<void> addImage() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 82, 93, 209),
              toolbarWidgetColor: const Color(0xff212121),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        if (croppedImage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Uploading please wait ...',
                style: TextStyle(
                  fontFamily: 'MyFont',
                ),
              ),
              backgroundColor: Color.fromARGB(255, 81, 97, 21),
            ),
          );

          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('gallery')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

          final uploadTask = storageRef.putFile(File(croppedImage.path));
          final snapshot = await uploadTask
              .whenComplete(() => {print('=================== Uploaded!!')});
          final downloadUrl = await snapshot.ref.getDownloadURL();
          print('=================== downloadUrl: $downloadUrl');

          // final userId = FirebaseAuth.instance.currentUser!.uid;
          DatabaseReference ref =
              FirebaseDatabase.instance.ref('gallery').push();

          await ref.set({
            'id': ref.key!,
            'image': downloadUrl,
            'date': DateTime.now().toString()
          });

          images.add(
            {
              'id': ref.key!,
              'image': downloadUrl,
              'date': DateTime.now().toString(),
            },
          );

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Succuessfully Uploaded',
                style: TextStyle(
                  fontFamily: 'MyFont',
                ),
              ),
              backgroundColor: Color.fromARGB(255, 26, 115, 75),
            ),
          );
        } else {
          log('Image cropping canceled.');
        }
      } else {
        log('No image selected.');
      }
    } on firebase_storage.FirebaseException catch (e) {
      log('Error in addImage: $e');
      // Print the full exception for more details
      log('Full exception: $e');
    }
  }

  void deleteImage(String imageId) {
    _databaseReference.child(imageId).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFF),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 54, 53, 53),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: const Text(
            "Upload Gallery",
            style: TextStyle(
              fontFamily: "Urbanist-Regular",
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 38, 78, 202),
                          ),
                          onPressed: () {
                            addImage();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text(
                                "Upload",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.maxFinite,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 229, 231, 235),
                  ),
                  color: const Color.fromARGB(255, 249, 250, 251),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 40, top: 20),
                  child: Text(
                    "Your Gallery",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 68, 70, 73),
                    ),
                  ),
                ),
              ),
              Column(
                children: images
                    .asMap()
                    .entries
                    .map(
                      (e) => Container(
                        width: double.maxFinite,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 229, 231, 235),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: CachedNetworkImage(
                                    width: 70,
                                    height: 70,
                                    imageUrl: e.value['image'] ?? '',
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    DateFormat('MMM, dd yyyy').format(
                                        DateTime.parse(e.value['date']!)),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color.fromARGB(122, 52, 51, 51),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      deleteImage(e.value['id']!);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
