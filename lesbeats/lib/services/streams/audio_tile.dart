import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../main.dart';
import '../../screens/profile/profile.dart';
import '../../widgets/responsive.dart';
import '../player/player.dart';

class MyAudioTile extends StatefulWidget {
  const MyAudioTile(
      {super.key,
      required this.snapshot,
      required this.index,
      required this.isProfileOpened});

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;
  final bool isProfileOpened;

  @override
  State<MyAudioTile> createState() => _MyAudioTileState();
}

class _MyAudioTileState extends State<MyAudioTile> {
  late Timestamp date;
  late String cover;
  late String path;
  late String title;
  late double price;
  late String feature;
  late String genre;
  late String artistId;
  late String id;

  late final Stream<QuerySnapshot> downloadStream;
  late final Stream<QuerySnapshot> salesStream;
  late final Stream<QuerySnapshot> likeStream;
  late final Stream<QuerySnapshot> playStream;

  late final Stream<DocumentSnapshot> artistStream;

  bool liked = false;

  checkIfLiked(String trackId, String userId, int index) async {
    try {
      await db
          .collection("interactions")
          .doc(trackId)
          .collection("likes")
          .doc(userId)
          .get()
          .then((doc) {
        liked = doc.exists;

        return;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    date = widget.snapshot.data!.docs[widget.index]["uploadedAt"];
    cover = widget.snapshot.data!.docs[widget.index]["cover"];
    path = widget.snapshot.data!.docs[widget.index]["path"];
    title = widget.snapshot.data!.docs[widget.index]["title"];
    price = widget.snapshot.data!.docs[widget.index]["price"];
    feature = widget.snapshot.data!.docs[widget.index]["feature"];
    genre = widget.snapshot.data!.docs[widget.index]["genre"];
    artistId = widget.snapshot.data!.docs[widget.index]["artistId"];
    id = widget.snapshot.data!.docs[widget.index]["id"];

    downloadStream = db
        .collection("interactions")
        .doc(id)
        .collection("downloads")
        .snapshots();
    playStream =
        db.collection("interactions").doc(id).collection("plays").snapshots();
    salesStream =
        db.collection("interactions").doc(id).collection("sales").snapshots();
    likeStream =
        db.collection("interactions").doc(id).collection("likes").snapshots();
    artistStream = db.collection("users").doc(artistId).snapshots();

    checkIfLiked(id, auth.currentUser!.uid, widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder5<QuerySnapshot, QuerySnapshot, QuerySnapshot,
            QuerySnapshot, DocumentSnapshot>(
        streams: StreamTuple5(
            salesStream, playStream, downloadStream, likeStream, artistStream),
        builder: (context, snapshot) {
          Map<String, dynamic> play = {
            "uid": auth.currentUser!.uid,
            "timestamp": DateTime.now()
          };

          Map<String, dynamic> download = {
            "uid": auth.currentUser!.uid,
            "timestamp": DateTime.now()
          };

          Map<String, dynamic> like = {
            "uid": auth.currentUser!.uid,
            "timestamp": DateTime.now()
          };

          if (snapshot.snapshot1.connectionState == ConnectionState.waiting ||
              snapshot.snapshot2.connectionState == ConnectionState.waiting ||
              snapshot.snapshot3.connectionState == ConnectionState.waiting ||
              snapshot.snapshot4.connectionState == ConnectionState.waiting ||
              snapshot.snapshot5.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Animate(
                  effects: const [
                    ShimmerEffect(duration: Duration(seconds: 1))
                  ],
                  onComplete: ((controller) {
                    controller.repeat();
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 40,
                        decoration: const BoxDecoration(
                            color: Colors.black12, shape: BoxShape.circle),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 30,
                        width: screenSize(context).width * 0.6,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.snapshot1.hasData &&
              snapshot.snapshot2.hasData &&
              snapshot.snapshot3.hasData &&
              snapshot.snapshot4.hasData &&
              snapshot.snapshot5.hasData) {
            final Map<String, String> tags = {
              "title": title,
              "cover": cover,
              "artist": feature.toString().isEmpty
                  ? snapshot.snapshot5.data!["username"]
                  : "${snapshot.snapshot5.data!["username"]} ft $feature",
              "artistId": artistId
            };

            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  GestureDetector(
                    onDoubleTap: (() {
                      if (!liked) {
                        db
                            .collection("interactions")
                            .doc(id)
                            .collection("likes")
                            .doc(auth.currentUser!.uid)
                            .set(like);

                        setState(() {
                          liked = true;
                        });
                      } else {
                        db
                            .collection("interactions")
                            .doc(id)
                            .collection("likes")
                            .doc(auth.currentUser!.uid)
                            .delete();

                        setState(() {
                          liked = false;
                        });
                      }
                    }),
                    onTap: () {
                      db
                          .collection("interactions")
                          .doc(id)
                          .collection("plays")
                          .doc(auth.currentUser!.uid)
                          .set(play);
                      playOnline(context, path, tags);
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      minVerticalPadding: 20,
                      leading: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.hardEdge,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: "assets/images/loading.gif",
                              image: cover)),
                      title: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                const Iconify(
                                  Wpf.shopping_bag,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "R $price",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      decoration:
                                          snapshot.snapshot1.data!.size > 0
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            OpenContainer(
                              closedElevation: 0,
                              tappable: !widget.isProfileOpened,
                              closedColor: Colors.transparent,
                              closedBuilder: ((context, action) => Text(
                                    feature.toString().isEmpty
                                        ? snapshot.snapshot5.data!["username"]
                                        : "${snapshot.snapshot5.data!["username"]} ft $feature",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                              openBuilder: (context, action) =>
                                  MyProfilePage(artistId),
                            ),
                            const Text(" | "),
                            Text(genre)
                          ],
                        ),
                      ),
                      trailing: PopupMenuButton(
                          itemBuilder: ((context) => [
                                PopupMenuItem(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.download),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Download"),
                                  ],
                                )),
                                PopupMenuItem(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.check_circle),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Buy"),
                                  ],
                                )),
                                const PopupMenuItem(
                                    height: 2, child: Divider()),
                                PopupMenuItem(
                                    child: Row(
                                  children: const [
                                    Icon(Icons.share),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Share"),
                                  ],
                                )),
                                PopupMenuItem(
                                    child: Row(
                                  children: const [
                                    Icon(Icons.report),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Report"),
                                  ],
                                )),
                              ])),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "${DateTime.now().difference(date.toDate()).inDays} days ago",
                          style: const TextStyle(color: Colors.black45),
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                snapshot.snapshot2.data!.size.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.download_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                snapshot.snapshot3.data!.size.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!liked) {
                                db
                                    .collection("interactions")
                                    .doc(id)
                                    .collection("likes")
                                    .doc(auth.currentUser!.uid)
                                    .set(like);

                                setState(() {
                                  liked = true;
                                });
                              } else {
                                db
                                    .collection("interactions")
                                    .doc(id)
                                    .collection("likes")
                                    .doc(auth.currentUser!.uid)
                                    .delete();

                                setState(() {
                                  liked = false;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 18,
                                  color: liked
                                      ? Theme.of(context).indicatorColor
                                      : Colors.grey,
                                ),
                                Text(
                                  snapshot.snapshot4.data!.size.toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider()
                ],
              ),
            );
          }

          return const SizedBox();
        });
  }
}
