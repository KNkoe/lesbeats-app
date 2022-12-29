import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:lesbeats/services/stream/follow.dart';
import 'package:lesbeats/services/stream/like.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../main.dart';
import '../../widgets/load.dart';
import '../../screens/profile/profile.dart';
import '../player/player.dart';
import 'delete.dart';
import 'download.dart';

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
  late bool download;

  late final Stream<QuerySnapshot> downloadStream;
  late final Stream<QuerySnapshot> salesStream;
  late final Stream<QuerySnapshot> likeStream;
  late final Stream<QuerySnapshot> playStream;

  late final Stream<DocumentSnapshot> artistStream;

  bool liked = false;
  bool following = false;

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
      debugPrint("LIKED = $liked");
    });
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
    download = widget.snapshot.data!.docs[widget.index]["download"];

    downloadStream =
        db.collection("tracks").doc(id).collection("downloads").snapshots();
    playStream =
        db.collection("tracks").doc(id).collection("plays").snapshots();
    salesStream =
        db.collection("tracks").doc(id).collection("sales").snapshots();
    likeStream =
        db.collection("tracks").doc(id).collection("likes").snapshots();
    artistStream = db.collection("users").doc(artistId).snapshots();

    checkIfLiked(id);

    getFollow();
  }

  getFollow() async {
    await db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .doc(artistId)
        .get()
        .then((doc) {
      following = doc.exists;
    });
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

          if (snapshot.snapshot1.connectionState == ConnectionState.waiting ||
              snapshot.snapshot2.connectionState == ConnectionState.waiting ||
              snapshot.snapshot3.connectionState == ConnectionState.waiting ||
              snapshot.snapshot4.connectionState == ConnectionState.waiting ||
              snapshot.snapshot5.connectionState == ConnectionState.waiting) {
            return const LoadTrack();
          }

          if (snapshot.snapshot1.hasData &&
              snapshot.snapshot2.hasData &&
              snapshot.snapshot3.hasData &&
              snapshot.snapshot4.hasData &&
              snapshot.snapshot5.hasData) {
            final Map<String, String> tags = {
              "id": id,
              "title": title,
              "cover": cover,
              "artist": feature.toString().isEmpty
                  ? snapshot.snapshot5.data!["username"]
                  : "${snapshot.snapshot5.data!["username"]} ft $feature",
              "artistId": artistId
            };

            final timeDifference = DateTime.now().difference(date.toDate());
            final timeAgo = DateTime.now().subtract(timeDifference);

            return GestureDetector(
              onDoubleTap: (() async {
                if (!liked) {
                  likeTrack(id);
                } else {
                  unlikeTrack(id);
                }

                setState(() {
                  checkIfLiked(id);
                });
              }),
              onTap: () {
                db
                    .collection("tracks")
                    .doc(id)
                    .collection("plays")
                    .doc(auth.currentUser!.uid)
                    .set(play);
                playOnline(context, path, tags);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
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
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
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
                            Text(
                              " | $genre",
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                      ),
                      trailing: PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20).copyWith(
                                  topRight: const Radius.circular(0))),
                          itemBuilder: ((context) => [
                                if (download)
                                  PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                            Duration.zero,
                                            () => showDialog(
                                                context: context,
                                                barrierColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    MyDownload(
                                                        title: title,
                                                        id: id,
                                                        producer: snapshot
                                                            .snapshot5
                                                            .data!["username"],
                                                        producerId: artistId,
                                                        downloadUrl: path)));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.download),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Download"),
                                        ],
                                      )),
                                if (artistId == auth.currentUser!.uid)
                                  PopupMenuItem(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.update),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Update"),
                                    ],
                                  )),
                                if (artistId == auth.currentUser!.uid)
                                  PopupMenuItem(
                                      onTap: () {
                                        Future.delayed(
                                                Duration.zero,
                                                () => deleteTrack(
                                                    context, id, title))
                                            .then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Delete"),
                                        ],
                                      )),
                                if (artistId != auth.currentUser!.uid)
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
                                if (artistId != auth.currentUser!.uid)
                                  PopupMenuItem(
                                      onTap: () {
                                        if (following) {
                                          unfollow(
                                              auth.currentUser!.uid, artistId);

                                          setState(() {
                                            following = false;
                                          });
                                        } else {
                                          follow(
                                              auth.currentUser!.uid, artistId);
                                          setState(() {
                                            following = true;
                                          });
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(following
                                              ? Icons.thumb_down
                                              : Icons.thumb_up),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(following
                                              ? "Unfollow"
                                              : "Follow"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            timeago.format(timeAgo),
                            style: Theme.of(context).textTheme.bodyText2,
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
                            if (download)
                              const SizedBox(
                                width: 20,
                              ),
                            if (download)
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierColor: Colors.transparent,
                                      builder: ((context) {
                                        return MyDownload(
                                            id: id,
                                            title: title,
                                            producerId: artistId,
                                            producer: snapshot
                                                .snapshot5.data!["username"],
                                            downloadUrl: path);
                                      }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.download_rounded,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        snapshot.snapshot3.data!.size
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!liked) {
                                  likeTrack(id);

                                  setState(() {
                                    liked = true;
                                  });
                                } else {
                                  unlikeTrack(id);

                                  setState(() {
                                    liked = false;
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
              ),
            );
          }

          return const SizedBox();
        });
  }
}
