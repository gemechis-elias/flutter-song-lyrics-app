import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../admin/dashboard.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login as Admin'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 102, 104, 111),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onPressed: () async {
            // signIn
            try {
              // Set a flag to indicate that the login process is in progress
              setState(() {
                _isLoading = true;
              });

              final credential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              );

              // save user id
              log("User ID: ${credential.user!.uid}");
              // ignore: use_build_context_synchronously
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashbaord(user: credential.user!),
                ),
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                log('No user found for that email.');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No user found for that email.',
                      style: TextStyle(
                        fontFamily: 'MyFont',
                      ),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                // close the dialog
                Navigator.pop(context);
                log('Email or Password is incorrect.');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Email or Password is incorrect.',
                      style: TextStyle(
                        fontFamily: 'MyFont',
                      ),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } finally {
              // Reset the flag once the login process is completed (whether successful or not)
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: _isLoading
              ? const CircularProgressIndicator(
                  color: Colors.black,
                ) // Show a CircularProgressIndicator if login is in progress
              : const Text(
                  "  Login  ",
                  style: TextStyle(color: Color.fromARGB(255, 241, 241, 241)),
                ),
        ),
      ],
    );
  }
}
