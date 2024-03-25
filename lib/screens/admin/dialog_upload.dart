import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UploadDialog extends StatefulWidget {
  final String value;
  const UploadDialog({Key? key, required this.value}) : super(key: key);

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _chordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Song Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Author',
            ),
          ),
          TextField(
            controller: _chordController,
            decoration: const InputDecoration(
              hintText: "C Major",
              labelText: 'Chord',
            ),
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
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("songs").push();

            try {
              await ref.set({
                "id": ref.key,
                "lyrics": widget.value,
                "chord": _chordController.text,
                "title": _titleController.text,
                "author": _authorController.text,
              });

              // show toast message when data inserted successfully
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color.fromARGB(255, 25, 88, 54),
                  content: Text(
                    'Song Uploaded Successfully',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );

              Navigator.pop(context);
            } catch (e) {
              print(e);
            }
          },
          child: _isLoading
              ? const CircularProgressIndicator(
                  color: Colors.black,
                ) // Show a CircularProgressIndicator if login is in progress
              : const Text(
                  "  Upload  ",
                  style: TextStyle(color: Color.fromARGB(255, 241, 241, 241)),
                ),
        ),
      ],
    );
  }
}
