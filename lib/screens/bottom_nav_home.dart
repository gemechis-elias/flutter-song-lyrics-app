import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'about/about_us.dart';
import 'fav_screen/fav_screen.dart';
import 'gallery/gallery.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late final DatabaseReference _databaseReference;
  List<Map<dynamic, dynamic>> songs = [];
  late List<Widget> listOfStrings = [];
  @override
  void initState() {
    super.initState();
    fetchData();
    listOfStrings = [
      HomeScreen(songsData: songs),
      FavScreeen(songsData: songs),
      const GalleryScreen(),
      const AboutScreen(),
    ];
  }

  void fetchData() {
    _databaseReference = FirebaseDatabase.instance.ref().child('songs');

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
                  item['lyrics'] != null &&
                  item['chord'] != null &&
                  item['author'] != null &&
                  item['title'] != null) {
                log('Processing item: $item');
                Map<String, String> imageData = {
                  'id': item['id'],
                  'lyrics': item['lyrics'],
                  'title': item['title'],
                  'chord': item['chord'],
                  'author': item['author'],
                };
                newData.add(imageData);
              }
            });

            setState(() {
              songs = newData;
              listOfStrings = [
                HomeScreen(songsData: songs),
                FavScreeen(songsData: songs),
                const GalleryScreen(),
                const AboutScreen(),
              ];
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

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchData();
      },
      child: Scaffold(
        body: listOfStrings[_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            setState(() {
              _currentIndex = i;
              log(_currentIndex.toString());
            });
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.book),
              title: const Text("መዝሙሮች"),
              selectedColor: const Color.fromARGB(255, 35, 136, 244),
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_border_outlined),
              title: const Text("የተወደዱ"),
              selectedColor: const Color.fromARGB(255, 35, 136, 244),
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.photo_library),
              title: const Text("ጋለሪ"),
              selectedColor: const Color.fromARGB(255, 35, 136, 244),
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.info),
              title: const Text("ስለ ኳየሩ"),
              selectedColor: const Color.fromARGB(255, 35, 136, 244),
            ),
          ],
        ),
      ),
    );
  }
}
