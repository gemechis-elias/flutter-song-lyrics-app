import 'package:flutter/material.dart';
import 'package:mezmur_debter/widgets/lyrics_widget.dart';

class SongDetailsScreen extends StatefulWidget {
  final String title;
  final String chord;
  final String author;
  final String lyrics;

  const SongDetailsScreen(
      {super.key,
      required this.title,
      required this.chord,
      required this.author,
      required this.lyrics});

  @override
  State<SongDetailsScreen> createState() => _SongDetailsScreenState();
}

class _SongDetailsScreenState extends State<SongDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF292C31),
      appBar: AppBar(
        // backgroundColor: const Color(0xFF292C31),
        // foregroundColor: const Color(0xFFA9DED8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
              // color: Color(0xFFA9DED8),
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chord: ${widget.chord}',
                  style: const TextStyle(
                      // color: Colors.white,
                      ),
                ),
                Text(
                  'Written by: ${widget.author}',
                  style: const TextStyle(
                      // color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            LyricsWidget(lyrics: widget.lyrics),
          ],
        ),
      ),
    );
  }
}
