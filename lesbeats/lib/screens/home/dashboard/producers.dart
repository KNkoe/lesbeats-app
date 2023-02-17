import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/profile/profile.dart';

import '../../../widgets/audio/follow.dart';

class MyProducers extends StatefulWidget {
  const MyProducers({super.key});

  @override
  State<MyProducers> createState() => _MyArtistsState();
}

class _MyArtistsState extends State<MyProducers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("users")
            .orderBy("followers", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  try {
                    snapshot.data!.docs[index]["balance"];
                  } catch (e) {
                    snapshot.data!.docs[index].reference
                        .set({"balance": 0.00}, SetOptions(merge: true));
                  }
                  try {
                    if (snapshot.data!.docs[index]["uid"] !=
                        auth.currentUser!.uid) {
                      if (index > 10) {
                        return MyProducerTile(doc: snapshot.data!.docs[index]);
                      }
                    }
                  } catch (e) {
                    debugPrint(e.toString());
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
  int followers = 0;

  @override
  void initState() {
    super.initState();
    db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .doc(widget.doc["uid"])
        .snapshots()
        .listen((doc) {
      if (mounted) {
        setState(() {
          following = doc.exists;
        });
      }
    });

    db
        .collection("users")
        .doc(widget.doc["uid"])
        .collection("followers")
        .snapshots()
        .listen((value) {
      if (mounted) {
        setState(() {
          followers = value.size;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedColor: Colors.transparent,
        closedElevation: 0,
        closedBuilder: ((context, action) => Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: FadeInImage(
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                "assets/images/placeholder.jpg"),
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
                                  color: Colors.green,
                                )
                            ],
                          ),
                          Text(
                            "$followers Followers",
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      ),
                    ],
                  ),
                  if (widget.doc["uid"] != auth.currentUser!.uid)
                    Row(
                      children: [
                        // OpenContainer(
                        //     closedElevation: 0,
                        //     closedColor: Colors.transparent,
                        //     closedBuilder: ((context, action) => Icon(
                        //           Icons.message,
                        //           color: Theme.of(context).primaryColor,
                        //         )),
                        //     openBuilder: ((context, action) =>
                        //         MyChat(userId: widget.doc["uid"]))),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: (following)
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
        openBuilder: ((context, action) => MyProfilePage(widget.doc["uid"])));
  }
}
