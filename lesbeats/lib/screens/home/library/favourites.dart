import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';
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
            return CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
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

  @override
  void initState() {
    super.initState();
    _trackStream = db.collection("tracks").doc(widget.id).snapshots();
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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
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
                subtitle: StreamBuilder<DocumentSnapshot>(
                    stream: _producerStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return OpenContainer(
                          closedElevation: 0,
                          closedBuilder: (context, function) {
                            return Text(feature.toString().isEmpty
                                ? snapshot.data!["username"]
                                : "${snapshot.data!["username"]} ft $feature");
                          },
                          openBuilder: (context, action) =>
                              MyProfilePage(artistId),
                        );
                      }

                      return const SizedBox();
                    }),
              ),
            );
          }

          return const SizedBox();
        });
  }
}
