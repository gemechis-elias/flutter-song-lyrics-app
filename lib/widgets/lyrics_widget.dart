import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class LyricsWidget extends StatelessWidget {
  final String lyrics;

  LyricsWidget({required this.lyrics});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: HtmlWidget(
              lyrics,
              enableCaching: true,

              renderMode: RenderMode.column,

              // set the default styling for text
              textStyle: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
