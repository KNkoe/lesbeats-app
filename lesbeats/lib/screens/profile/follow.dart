import '../../main.dart';

follow(String follower, String followed) {
  db
      .collection("follows")
      .doc(followed)
      .collection("followers")
      .doc(follower)
      .set({"uid": follower, "timestamp": DateTime.now()});

  db
      .collection("follows")
      .doc(follower)
      .collection("following")
      .doc(followed)
      .set({"uid": followed, "timestamp": DateTime.now()});
}

unfollow(String follower, String followed) {
  db
      .collection("follows")
      .doc(followed)
      .collection("followers")
      .doc(follower)
      .delete();

  db
      .collection("follows")
      .doc(follower)
      .collection("following")
      .doc(followed)
      .delete();
}
