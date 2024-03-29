import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

likeTrack(String id) async {
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

  await track.then((value) {
    title = value.get("title");
    producer = value.get("artistId");
  });

  if (producer != auth.currentUser!.uid) {
    final likeNotification = {
      "message": "${auth.currentUser!.displayName} liked your beat $title",
      "timestamp": DateTime.now(),
      "read": false,
      "type": "like"
    };
    db
        .collection("users")
        .doc(producer)
        .collection("notifications")
        .doc("${auth.currentUser!.uid}-liked-$id")
        .set(likeNotification);
  }

  Get.showSnackbar(const GetSnackBar(
    isDismissible: true,
    duration: Duration(seconds: 2),
    backgroundColor: Color(0xff264653),
    borderRadius: 30,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    icon: Icon(
      Icons.check,
      color: Colors.white,
    ),
    message: "Liked",
  ));
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

  Get.showSnackbar(const GetSnackBar(
    isDismissible: true,
    duration: Duration(seconds: 2),
    backgroundColor: Color(0xff264653),
    borderRadius: 30,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    icon: Icon(
      Icons.check,
      color: Colors.white,
    ),
    message: "Unliked",
  ));
}
