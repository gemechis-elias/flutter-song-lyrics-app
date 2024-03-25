import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mezmur_debter/screens/admin/edit_lyrics.dart';

class UploadLysrics extends StatefulWidget {
  const UploadLysrics({Key? key}) : super(key: key);

  @override
  _UploadLysricsState createState() => _UploadLysricsState();
}

class _UploadLysricsState extends State<UploadLysrics> {
  late DatabaseReference _databaseReference;
  List<Map<String, String>> songs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// ...

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
                  item['title'] != null) {
                log('Processing item: $item');
                Map<String, String> imageData = {
                  'id': item['id'],
                  'lyrics': item['lyrics'],
                  'title': item['title'],
                };
                newData.add(imageData);
              }
            });

            setState(() {
              songs = newData;
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
            "Upload Songs",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditLayricsPage(
                                  title: 'Add Lyrics',
                                ),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8), // Adjust spacing as needed
                              Text(
                                "Write Lyrics",
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
                    "All Songs List",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 68, 70, 73),
                    ),
                  ),
                ),
              ),
              Column(
                children: songs
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
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    e.value!['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color.fromARGB(122, 52, 51, 51),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
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
