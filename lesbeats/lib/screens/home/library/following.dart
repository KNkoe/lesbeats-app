import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';

class MyFollowingPage extends StatefulWidget {
  const MyFollowingPage({super.key});

  @override
  State<MyFollowingPage> createState() => _MyFollowingPageState();
}

class _MyFollowingPageState extends State<MyFollowingPage> {
  late final Stream<QuerySnapshot> _followingStream;

  @override
  void initState() {
    super.initState();
    _followingStream = db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _followingStream,
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
            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text("You have not followed anyone"),
              );
            }
            return Expanded(
                child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return FollowingTile(uid: snapshot.data!.docs[index]["uid"]);
              },
            ));
          }

          return const SizedBox();
        });
  }
}

class FollowingTile extends StatefulWidget {
  const FollowingTile({super.key, required this.uid});
  final String uid;

  @override
  State<FollowingTile> createState() => _FollowingTileState();
}

class _FollowingTileState extends State<FollowingTile> {
  late final Stream<DocumentSnapshot> _followingDoc;

  @override
  void initState() {
    super.initState();
    _followingDoc = db.collection("users").doc(widget.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _followingDoc,
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

          if (snapshot.hasData && snapshot.data!.exists) {
            return OpenContainer(
              closedElevation: 0,
              closedColor: Colors.transparent,
              closedBuilder: (context, action) => Column(
                children: [
                  ClipOval(
                      child: FadeInImage.assetNetwork(
                    image: snapshot.data!["photoUrl"],
                    placeholder: "assets/images/loading.gif",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(snapshot.data!["username"])
                ],
              ),
              openBuilder: (context, action) => MyProfilePage(widget.uid),
            );
          }

          return const SizedBox();
        });
  }
}
