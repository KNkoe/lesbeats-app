import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/genre/tracks.dart';

class MyGenres extends StatefulWidget {
  const MyGenres({super.key, required this.uid});
  final String uid;

  @override
  State<MyGenres> createState() => _MyGenresState();
}

class _MyGenresState extends State<MyGenres> {
  late Stream<QuerySnapshot> _myGenresStream;
  List<String> genres = [];

  @override
  void initState() {
    super.initState();
    _myGenresStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: widget.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _myGenresStream,
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
            if (!genres.contains(element.get("genre"))) {
              genres.add(element.get("genre"));
            }
          }

          return Expanded(
              child: ListView(
            children: genres
                .map((genre) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: OpenContainer(
                          closedBuilder: ((context, action) => ListTile(
                                leading: const Icon(Icons.folder),
                                title: Text(genre),
                              )),
                          openBuilder: ((context, action) {
                            return MyTracks(
                              genre: genre,
                              uid: widget.uid,
                            );
                          })),
                    ))
                .toList(),
          ));
        }

        return const SizedBox();
      },
    );
  }
}
