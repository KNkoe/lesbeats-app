import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesbeats/main.dart';

moveTrack(String id, String folder) {
  db
      .collection("tracks")
      .doc(id)
      .set({"folder": folder}, SetOptions(merge: true));
}
