import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  late final Stream<QuerySnapshot> likeStream;

  @override
  void initState() {
    super.initState();
    likeStream =
        db.collection("interactions").doc().collection("likes").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: likeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            );
          }

          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data!.size.toString()),
            );
          }

          return const SizedBox();
        });
  }
}
