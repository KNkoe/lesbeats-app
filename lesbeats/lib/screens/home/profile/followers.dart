import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/dashboard/producers.dart';
import 'package:lesbeats/widgets/load.dart';

class MyFollowers extends StatelessWidget {
  const MyFollowers({super.key, required this.snapshot, required this.follow});
  final QuerySnapshot? snapshot;
  final String follow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Theme.of(context).textTheme.headline6!.color,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          follow,
          style: Theme.of(context).textTheme.headline6!,
        ),
      ),
      body: (snapshot!.size == 0)
          ? Center(child: Text("0 $follow"))
          : ListView.builder(
              itemCount: snapshot!.size,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) {
                return MyFollowerTile(doc: snapshot!.docs[index]);
              })),
    );
  }
}

class MyFollowerTile extends StatefulWidget {
  const MyFollowerTile({super.key, required this.doc});
  final DocumentSnapshot doc;

  @override
  State<MyFollowerTile> createState() => _MyFollowerTileState();
}

class _MyFollowerTileState extends State<MyFollowerTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.collection("users").doc(widget.doc["uid"]).snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadTrack();
          }

          if (snapshot.hasData) {
            return MyProducerTile(doc: snapshot.data!);
          }

          return const SizedBox();
        }));
  }
}
