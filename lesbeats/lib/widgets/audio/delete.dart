import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/decoration.dart';

deleteTrack(BuildContext context, String id, String title) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete?"),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            OutlinedButton(
                style: cancelButtonStyle,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await db
                        .collection("tracks")
                        .doc(id)
                        .collection("likes")
                        .get()
                        .then((value) {
                      if (value.docs.isNotEmpty) {
                        for (var element in value.docs) {
                          element.reference.delete();
                        }
                      }
                    });

                    await db
                        .collection("tracks")
                        .doc(id)
                        .collection("downloads")
                        .get()
                        .then((value) {
                      if (value.docs.isNotEmpty) {
                        for (var element in value.docs) {
                          element.reference.delete();
                        }
                      }
                    });

                    await db
                        .collection("tracks")
                        .doc(id)
                        .collection("plays")
                        .get()
                        .then((value) {
                      if (value.docs.isNotEmpty) {
                        for (var element in value.docs) {
                          element.reference.delete();
                        }
                      }
                    });

                    await db.collection("tracks").doc(id).delete();

                    final storageRef =
                        storage.ref("/tracks/${auth.currentUser!.uid}/$title/");
                    storageRef
                        .listAll()
                        .then((value) =>
                            storage.ref(value.items.first.fullPath).delete())
                        .then((value) {
                      Navigator.pop(context);

                      Get.showSnackbar(const GetSnackBar(
                        isDismissible: true,
                        duration: Duration(seconds: 5),
                        backgroundColor: Color(0xff264653),
                        borderRadius: 30,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        message: "Deleted successfully",
                      ));
                    });
                  } catch (e) {
                    debugPrint("DELETE ERROR $e");
                  }
                },
                style: confirmButtonStyle,
                child: const Text("Delete"))
          ],
        );
      });
}
