import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mezmur_debter/screens/about/login_dialog.dart';

import '../admin/dashboard.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'About Choir',
              style: TextStyle(
                fontFamily: 'Satisfy',
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 25,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "“አዲስ ቅኔም ተቀኙለት፥ በእልልታም መልካም ዝማሬ ዘምሩ፤” — መዝሙር 33፥3",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    // User is already authenticated, navigate to the dashboard
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Dashbaord(user: FirebaseAuth.instance.currentUser!),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LoginDialog();
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff181A1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Login as Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MontserratRegular',
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 170,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(
                    bottom: 16), // Adjust the bottom margin as needed
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Developed by Horan Software",
                    style: TextStyle(
                      color: Color.fromARGB(130, 158, 158, 158),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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

  void _showLoginDialog(BuildContext context) {}
}
