import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesbeats/main.dart';

DocumentSnapshot? getArtist(String id) {
  final Stream<DocumentSnapshot> artistStream =
      db.collection("users").doc(id).snapshots();

  DocumentSnapshot? artist;

  artistStream.listen((event) {
    if (event.id == id) {
      artist = event;
    }
  });

  return artist;
}
