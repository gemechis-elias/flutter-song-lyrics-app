import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _currentPasswordController,
            decoration: const InputDecoration(labelText: 'Current Password'),
            obscureText: true,
          ),
          TextField(
            controller: _newPasswordController,
            decoration: const InputDecoration(labelText: 'New Password'),
            obscureText: true,
          ),
          TextField(
            controller: _confirmNewPasswordController,
            decoration:
                const InputDecoration(labelText: 'Confirm New Password'),
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
            backgroundColor: const Color(0xff181A1F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          onPressed: () async {
            // Change password logic
            try {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // Reauthenticate the user with the current password
                final credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: _currentPasswordController.text,
                );

                await user.reauthenticateWithCredential(credential);

                // Change the password
                await user.updatePassword(_newPasswordController.text);

                // Close the dialog
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password changed successfully',
                      style: TextStyle(
                        fontFamily: 'MyFont',
                      ),
                    ),
                    backgroundColor: Color.fromARGB(255, 82, 151, 85),
                  ),
                );
              }
            } on FirebaseAuthException catch (e) {
              // Handle authentication exceptions
              // Display error message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to change password: ${e.message}',
                    style: const TextStyle(fontFamily: 'MyFont'),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Change Password',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
