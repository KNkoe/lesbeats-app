import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/services/stream/like.dart';
import 'package:lesbeats/widgets/load.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  late final Stream<QuerySnapshot> _favoritesStream;

  @override
  void initState() {
    super.initState();
    _favoritesStream = db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("favorites")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _favoritesStream,
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
            return Expanded(
                child: ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: ((context, index) {
                return TrackTile(id: snapshot.data!.docs[index]["id"]);
              }),
            ));
          }

          return const SizedBox();
        });
  }
}

class TrackTile extends StatefulWidget {
  const TrackTile({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  late Stream<DocumentSnapshot> _trackStream;
  late Stream<DocumentSnapshot> _producerStream;

  bool liked = true;

  checkIfLiked(String trackId) async {
    await db
        .collection("tracks")
        .doc(trackId)
        .collection("likes")
        .doc(
          auth.currentUser!.uid,
        )
        .get()
        .then((doc) {
      liked = doc.exists;
    });
  }

  @override
  void initState() {
    super.initState();
    _trackStream = db.collection("tracks").doc(widget.id).snapshots();

    checkIfLiked(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _trackStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadTrack();
          }

          if (snapshot.hasData) {
            final date = snapshot.data!["uploadedAt"];
            final cover = snapshot.data!["cover"];
            final path = snapshot.data!["path"];
            final title = snapshot.data!["title"];
            final price = snapshot.data!["price"];
            final feature = snapshot.data!["feature"];
            final genre = snapshot.data!["genre"];
            final artistId = snapshot.data!["artistId"];
            final id = snapshot.data!["id"];

            _producerStream = db.collection("users").doc(artistId).snapshots();

            return ListTile(
                leading: Container(
                    height: 70,
                    width: 70,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.hardEdge,
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/images/loading.gif",
                        image: cover)),
                title: Text(title),
                subtitle: Row(
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: _producerStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return OpenContainer(
                              closedElevation: 0,
                              closedBuilder: (context, function) {
                                return Text(
                                  feature.toString().isEmpty
                                      ? snapshot.data!["username"]
                                      : "${snapshot.data!["username"]} ft $feature",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                );
                              },
                              openBuilder: (context, action) =>
                                  MyProfilePage(artistId),
                            );
                          }

                          return const SizedBox();
                        }),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          if (!liked) {
                            likeTrack(id);
                            checkIfLiked(widget.id);

                            setState(() {});
                          } else {
                            unlikeTrack(id);
                            checkIfLiked(widget.id);

                            setState(() {});
                          }
                        },
                        child: Icon(
                          Icons.favorite,
                          color: liked
                              ? Theme.of(context).indicatorColor
                              : Colors.grey,
                        ))
                  ],
                ),
                isThreeLine: true,
                trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return [const PopupMenuItem(child: Text("Report"))];
                    }));
          }

          return const SizedBox();
        });
  }
}
