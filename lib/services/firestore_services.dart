// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lyrics_app/models/song.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> addSong(Song song) async {
//     try {
//       await _firestore.collection('songs').add(song.toMap());
//     } catch (e) {
//       print('Error adding song: $e');
//     }
//   }
//
//   Future<List<Song>> getAllSongs() async {
//     try {
//       final QuerySnapshot snapshot = await _firestore.collection('songs').get();
//       return snapshot.docs.map((doc) => Song.fromMap(doc.data())).toList();
//     } catch (e) {
//       print('Error fetching songs: $e');
//       return [];
//     }
//   }
//
// // Implement updateSong, deleteSong, and other methods as needed.
// }
