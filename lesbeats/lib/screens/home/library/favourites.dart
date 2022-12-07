import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/services/streams/audio_stream.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  late Stream<QuerySnapshot> _favoritesStream;

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
    return Expanded(
      child: getStream(_favoritesStream),
    );
  }
}
