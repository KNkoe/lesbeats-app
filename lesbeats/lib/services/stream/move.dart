import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/decoration.dart';

import '../../widgets/responsive.dart';

moveTracks(BuildContext context, String id) {
  showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: ((context) => MoveTrack(id: id)));
}

class MoveTrack extends StatefulWidget {
  const MoveTrack({super.key, required this.id});

  final String id;

  @override
  State<MoveTrack> createState() => _MoveTrackState();
}

class _MoveTrackState extends State<MoveTrack> {
  String track = "";

  final folders = [];
  final TextEditingController _folderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentTrackFolder();
  }

  currentTrackFolder() async {
    final doc = db.collection("tracks").doc(widget.id).get();

    await doc.then((value) {
      setState(() {
        track = value.get("folder");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("tracks")
            .where("artistId", isEqualTo: auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                "assets/images/loading.gif",
                height: 70,
                width: 70,
              ),
            );
          }

          if (snapshot.hasData) {
            try {
              for (var element in snapshot.data!.docs) {
                final file = element.get("folder");

                if (!folders.contains(file)) {
                  folders.add(file);
                }
              }
            } catch (e) {
              debugPrint(e.toString());
            }

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    title: Column(
                      children: [
                        const Text("Move to folder"),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: screenSize(context).width * 0.5,
                              child: TextFormField(
                                controller: _folderController,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  label: Text("New folder"),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (_folderController.text.isNotEmpty) {
                                    db.collection("tracks").doc(widget.id).set(
                                        {"folder": _folderController.text},
                                        SetOptions(merge: true)).then((value) {
                                      currentTrackFolder();
                                      Get.showSnackbar(GetSnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor:
                                            const Color(0xff264653),
                                        borderRadius: 30,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 30),
                                        icon: const Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                        ),
                                        message:
                                            "Added to ${_folderController.text} folder successfully",
                                      ));
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.add_box_rounded,
                                  size: 32,
                                  color: Theme.of(context).primaryColor,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            height: screenSize(context).height * 0.4,
                            width: screenSize(context).width,
                            child: ListView.builder(
                              itemCount: folders.length,
                              itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    db.collection("tracks").doc(widget.id).set(
                                        {"folder": folders[index]},
                                        SetOptions(merge: true)).then((value) {
                                      currentTrackFolder();

                                      Get.showSnackbar(GetSnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor:
                                            const Color(0xff264653),
                                        borderRadius: 30,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 30),
                                        icon: const Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                        ),
                                        message:
                                            "Added to ${folders[index]} folder successfully",
                                      ));
                                    });
                                  },
                                  leading: Icon(
                                    Icons.folder,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: Text(folders[index]),
                                  trailing: track == folders[index]
                                      ? const Text(
                                          "Current",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : const SizedBox()),
                            ))
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      OutlinedButton(
                          style: cancelButtonStyle,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close")),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        });
  }
}
