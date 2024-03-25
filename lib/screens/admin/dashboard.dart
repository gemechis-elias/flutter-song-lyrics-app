import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mezmur_debter/screens/admin/change_password.dart';

import 'upload_gallery.dart';
import 'upload_lyrics.dart';

class Dashbaord extends StatefulWidget {
  final User? user;
  const Dashbaord({Key? key, required this.user}) : super(key: key);

  @override
  State<Dashbaord> createState() => _DashbaordState();
}

class _DashbaordState extends State<Dashbaord> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffF8FAFF),
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
            child: Text(
              "Welcome, ${widget.user!.displayName ?? "Admin"}",
              style: const TextStyle(
                fontFamily: "Urbanist-Regular",
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadLysrics(),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 194, 196, 233),
                    surfaceTintColor: const Color.fromARGB(255, 194, 196, 233),
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          SizedBox(
                            width: 110,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                "Add Lyrics",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    // UploadGallery();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadGallery(),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 194, 196, 233),
                    surfaceTintColor: const Color.fromARGB(255, 194, 196, 233),
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          SizedBox(
                            width: 110,
                            child: Icon(
                              Icons.image,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                "Add Gallery",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ChangePasswordDialog();
                      },
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 194, 196, 233),
                    surfaceTintColor: const Color.fromARGB(255, 194, 196, 233),
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          SizedBox(
                            width: 110,
                            child: Icon(
                              Icons.lock,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                "Change Password",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 194, 196, 233),
                    surfaceTintColor: const Color.fromARGB(255, 194, 196, 233),
                    margin: const EdgeInsets.all(0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          SizedBox(
                            width: 110,
                            child: Icon(
                              Icons.logout,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                "Logout",
                                maxLines: 4,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
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
        ),
      ),
    );
  }
}
