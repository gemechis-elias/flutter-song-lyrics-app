class Song {
  final String id;
  final String title;
  final List<String> lyrics;

  Song({
    required this.id,
    required this.title,
    required this.lyrics,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'lyrics': lyrics,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      lyrics: List<String>.from(map['lyrics']),
    );
  }
}
