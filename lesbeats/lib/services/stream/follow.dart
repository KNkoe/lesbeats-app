import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

follow(String follower, String followed) {
  db
      .collection("users")
      .doc(followed)
      .collection("followers")
      .doc(follower)
      .set({"uid": follower, "timestamp": DateTime.now()});

  db
      .collection("users")
      .doc(follower)
      .collection("following")
      .doc(followed)
      .set({"uid": followed, "timestamp": DateTime.now()});

  db.collection("users").doc(followed).collection("notifications").add(
      {"message": "${auth.currentUser!.displayName}started following you"});

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
    message: "Followed",
  ));
}

unfollow(String follower, String followed) {
  db
      .collection("users")
      .doc(followed)
      .collection("followers")
      .doc(follower)
      .delete();

  db
      .collection("users")
      .doc(follower)
      .collection("following")
      .doc(followed)
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
    message: "Unfollowed",
  ));
}
