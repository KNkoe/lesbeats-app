import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/genre/tracks.dart';

class MyFolders extends StatefulWidget {
  const MyFolders({super.key, required this.uid});
  final String uid;

  @override
  State<MyFolders> createState() => _MyFoldersState();
}

class _MyFoldersState extends State<MyFolders> {
  late Stream<QuerySnapshot> _MyFoldersStream;
  List<String> folders = [];

  @override
  void initState() {
    super.initState();
    _MyFoldersStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: widget.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _MyFoldersStream,
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
          for (var element in snapshot.data!.docs) {
            try {
              if (!folders.contains(element.get("folder"))) {
                folders.add(element.get("folder"));
              }
            } catch (e) {
              element.reference
                  .set({"folder": "default"}, SetOptions(merge: true));
            }
          }

          return Expanded(
              child: ListView(
            children: folders
                .map((folder) => ListTile(
                      leading: Icon(
                        Icons.folder,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(folder),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((context) {
                              return MyTracks(
                                folder: folder,
                                uid: widget.uid,
                              );
                            }));
                      },
                    ))
                .toList(),
          ));
        }

        return const SizedBox();
      },
    );
  }
}
