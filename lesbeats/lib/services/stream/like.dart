import '../../main.dart';

likeTrack(String id) {
  Map<String, dynamic> like = {
    "uid": auth.currentUser!.uid,
    "timestamp": DateTime.now()
  };

  db
      .collection("tracks")
      .doc(id)
      .collection("likes")
      .doc(auth.currentUser!.uid)
      .set(like);

  db
      .collection("users")
      .doc(auth.currentUser!.uid)
      .collection("favorites")
      .doc(id)
      .set({"id": id, "timestamp": DateTime.now()});

  final track = db.collection("tracks").doc(id).get();
  String title = "";
  String producer = "";

  track.then((value) {
    title = value.get("title");
    producer = value.get("artistId");
  });

  db
      .collection("users")
      .doc(producer)
      .collection("notifications")
      .add({"message": "${auth.currentUser!.displayName} downloaded $title"});
}

unlikeTrack(String id) {
  db
      .collection("tracks")
      .doc(id)
      .collection("likes")
      .doc(auth.currentUser!.uid)
      .delete();

  db
      .collection("users")
      .doc(auth.currentUser!.uid)
      .collection("favorites")
      .doc(id)
      .delete();
}
