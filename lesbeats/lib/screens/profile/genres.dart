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
                .map((genre) => ListTile(
                      leading: Icon(
                        Icons.folder,
                        size: 32,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(genre),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((context) {
                              return MyTracks(
                                genre: genre,
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
