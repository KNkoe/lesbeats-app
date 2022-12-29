import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';

import '../../services/stream/follow.dart';

class MyProducers extends StatefulWidget {
  const MyProducers({super.key});

  @override
  State<MyProducers> createState() => _MyArtistsState();
}

class _MyArtistsState extends State<MyProducers> {
  late final Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    _usersStream = db.collection('users').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  if (snapshot.data!.docs[index]["uid"] !=
                      auth.currentUser!.uid) {
                    if (index > 4) {
                      return MyProducerTile(doc: snapshot.data!.docs[index]);
                    }
                  }
                  return const SizedBox();
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                "assets/images/loading.gif",
                height: 70,
                width: 70,
              ),
            );
          }
          return Container();
        });
  }
}

class MyProducerTile extends StatefulWidget {
  const MyProducerTile({super.key, required this.doc});
  final DocumentSnapshot doc;

  @override
  State<MyProducerTile> createState() => _MyProducerTileState();
}

class _MyProducerTileState extends State<MyProducerTile> {
  bool following = false;

  @override
  void initState() {
    super.initState();
    getFollow();
    getFollowers();
  }

  getFollow() async {
    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .doc(widget.doc["uid"])
        .get()
        .then((doc) {
      setState(() {
        following = doc.exists;
      });
    });
  }

  int followers = 0;

  getFollowers() async {
    await db
        .collection("users")
        .doc(widget.doc["uid"])
        .collection("followers")
        .get()
        .then((value) {
      setState(() {
        followers = value.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer(
          transitionDuration: const Duration(milliseconds: 100),
          closedBuilder: ((context, action) => Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage("assets/images/loading.gif"),
                              image: NetworkImage(widget.doc["photoUrl"])),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(widget.doc["username"]),
                                const SizedBox(
                                  width: 4,
                                ),
                                if (widget.doc["isVerified"])
                                  const Icon(
                                    Icons.verified_sharp,
                                    size: 18,
                                    color: Colors.white,
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  followers.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                                const Text(
                                  " Followers",
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.message,
                              color: Theme.of(context).primaryColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: (following)
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                            onPressed: () {
                              if (following) {
                                unfollow(
                                    auth.currentUser!.uid, widget.doc["uid"]);

                                setState(() {
                                  following = false;
                                });
                              } else {
                                follow(
                                    auth.currentUser!.uid, widget.doc["uid"]);
                                setState(() {
                                  following = true;
                                });
                              }
                            },
                            child: Text((following) ? "Following" : "Follow")),
                      ],
                    )
                  ],
                ),
              )),
          openBuilder: ((context, action) => MyProfilePage(widget.doc["uid"]))),
    );
  }
}
