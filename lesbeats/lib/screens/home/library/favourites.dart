import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lottie/lottie.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../../services/stream/audio_tile.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  late final Stream<QuerySnapshot> _favoritesStream;
  late final Stream<QuerySnapshot> _trackStream;
  List<QueryDocumentSnapshot<Object?>> favorites = [];

  @override
  void initState() {
    super.initState();
    _favoritesStream = db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("favorites")
        .snapshots();
    _trackStream = db.collection("tracks").snapshots();
  }

  @override
  void dispose() {
    favorites.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple2(_favoritesStream, _trackStream),
        builder: (context, snapshot) {
          if (snapshot.snapshot1.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                "assets/images/loading.gif",
                height: 70,
                width: 70,
              ),
            );
          }

          if (snapshot.snapshot1.hasData) {
            if (snapshot.snapshot2.hasData) {
              favorites.clear();
              final trackMap = snapshot.snapshot2.data!.docs.toList().asMap();

              try {
                for (var element in snapshot.snapshot1.data!.docs) {
                  var result = snapshot.snapshot2.data!.docs
                      .where((value) => value["id"] == element["id"]);

                  if (result.isNotEmpty) {
                    favorites.add(result.first);
                  }
                }
              } catch (e) {
                debugPrint(e.toString());
              }

              return Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  int indexoftrack = trackMap.keys.firstWhere(
                    (element) =>
                        favorites[index]["id"] == trackMap[element]!.get("id"),
                  );

                  if (favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network(
                              "https://assets1.lottiefiles.com/private_files/lf30_e3pteeho.json"),
                          const Text("No favourites")
                        ],
                      ),
                    );
                  }

                  return MyAudioTile(
                    snapshot: snapshot.snapshot2,
                    index: indexoftrack,
                    isProfileOpened: false,
                  );
                },
              ));
            }

            return const SizedBox();
          }

          return const SizedBox();
        });
  }
}
