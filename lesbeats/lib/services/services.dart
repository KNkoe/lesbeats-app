import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lesbeats/main.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      db.collection("users").doc(auth.currentUser!.uid).set(
          {'online': false, 'last seen': DateTime.now()},
          SetOptions(merge: true));
      debugPrint('The app is paused');
    } else if (state == AppLifecycleState.resumed) {
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set({'online': true}, SetOptions(merge: true));
      debugPrint('The app is resumed');
    } else if (state == AppLifecycleState.inactive) {
      db.collection("users").doc(auth.currentUser!.uid).set(
          {'online': false, 'last seen': DateTime.now()},
          SetOptions(merge: true));
      debugPrint('The app is inactive');
    } else if (state == AppLifecycleState.detached) {
      db.collection("users").doc(auth.currentUser!.uid).set(
          {'online': false, 'last seen': DateTime.now()},
          SetOptions(merge: true));
      debugPrint('The app is detached');
    }
  }
}
