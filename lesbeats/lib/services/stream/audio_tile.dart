import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:lesbeats/screens/home/checkout.dart';
import 'package:lesbeats/screens/home/features.dart';
import 'package:lesbeats/screens/home/edit_track.dart';
import 'package:lesbeats/services/stream/follow.dart';
import 'package:lesbeats/services/stream/like.dart';
import 'package:lesbeats/services/stream/report.dart';
import 'package:lesbeats/widgets/format.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../main.dart';
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
  int downloads = 0;
  int plays = 0;
  int likes = 0;
  late String producer = "";

  bool liked = false;
  bool following = false;

  Map<String, dynamic> play = {};
  Map<String, String> tags = {};
  DateTime timeAgo = DateTime.now();

  checkIfLiked(String trackId) {
    db
        .collection("tracks")
        .doc(trackId)
        .collection("likes")
        .doc(
          auth.currentUser!.uid,
        )
        .get()
        .then((doc) {
      if (mounted) {
        setState(() {
          liked = doc.exists;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    try {
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
      downloads = widget.snapshot.data!.docs[widget.index]["downloads"];
      plays = widget.snapshot.data!.docs[widget.index]["plays"];
      likes = widget.snapshot.data!.docs[widget.index]["likes"];
      producer = widget.snapshot.data!.docs[widget.index]["producer"];
    } catch (e) {
      debugPrint(e.toString());
    }

    final DocumentReference producerStream =
        db.collection("users").doc(artistId);
    final DocumentReference trackStream = db.collection("tracks").doc(id);
    final Stream<QuerySnapshot> playStream =
        trackStream.collection("plays").snapshots();
    final Stream<QuerySnapshot> likeStream =
        trackStream.collection("likes").snapshots();
    final Stream<QuerySnapshot> downloadStream =
        trackStream.collection("likes").snapshots();

    producerStream.snapshots().listen((event) {
      trackStream.set({"producer": event.get("username")},
          SetOptions(merge: true)).then((value) => debugPrint("UPDATED"));
    });

    playStream.listen((element) async {
      trackStream.set({"plays": element.size}, SetOptions(merge: true)).then(
          (value) => debugPrint("UPDATED"));
    });

    likeStream.listen((element) async {
      trackStream.set({"likes": element.size}, SetOptions(merge: true)).then(
          (value) => debugPrint("UPDATED"));
    });

    downloadStream.listen((element) async {
      trackStream.set({"downloads": element.size},
          SetOptions(merge: true)).then((value) => debugPrint("UPDATED"));
    });

    play = {"uid": auth.currentUser!.uid, "timestamp": DateTime.now()};
    tags = {
      "id": id,
      "title": title,
      "cover": cover,
      "artist": feature.toString().isEmpty ? producer : "$producer ft $feature",
      "artistId": artistId
    };

    final timeDifference = DateTime.now().difference(date.toDate());
    timeAgo = DateTime.now().subtract(timeDifference);
  }

  getFollow() {
    db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .doc(artistId)
        .get()
        .then((doc) {
      if (mounted) {
        setState(() {
          following = doc.exists;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFollow();
    checkIfLiked(id);
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.hardEdge,
                  child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: "assets/images/cover.jpg",
                      image: cover)),
              title: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        showFeatureNotAvail(context);
                      },
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
                            price == 0 ? "Free" : "R $price",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(decoration: TextDecoration.none),
                          )
                        ],
                      ),
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
                                ? producer
                                : "${producer} ft $feature",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      openBuilder: (context, action) => MyProfilePage(artistId),
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
                      borderRadius: BorderRadius.circular(10)
                          .copyWith(topRight: const Radius.circular(0))),
                  itemBuilder: ((context) => [
                        if (download)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(
                                    Duration.zero,
                                    () => showDialog(
                                        context: context,
                                        barrierColor: Colors.transparent,
                                        builder: (context) => MyDownload(
                                            title: title,
                                            id: id,
                                            producer: producer,
                                            producerId: artistId,
                                            downloadUrl: path)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Download"),
                                ],
                              )),
                        if (artistId == auth.currentUser!.uid)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero,
                                    () => showUpdate(context, id, price));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Edit"),
                                ],
                              )),
                        if (artistId == auth.currentUser!.uid)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero,
                                        () => deleteTrack(context, id, title))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Delete"),
                                ],
                              )),
                        if (artistId != auth.currentUser!.uid && price != 0)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(
                                    Duration.zero,
                                    () => showcheckout(context, title, price,
                                        id, artistId, producer));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Buy"),
                                ],
                              )),
                        if (artistId != auth.currentUser!.uid)
                          PopupMenuItem(
                              onTap: () {
                                if (following) {
                                  unfollow(auth.currentUser!.uid, artistId);

                                  setState(() {
                                    following = false;
                                  });
                                } else {
                                  follow(auth.currentUser!.uid, artistId);
                                  setState(() {
                                    following = true;
                                  });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    following
                                        ? Icons.thumb_down
                                        : Icons.thumb_up,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(following ? "Unfollow" : "Follow"),
                                ],
                              )),
                        const PopupMenuItem(height: 2, child: Divider()),
                        // PopupMenuItem(
                        //     child: Row(
                        //   children: const [
                        //     Icon(Icons.share),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     Text("Share"),
                        //   ],
                        // )),
                        if (artistId != auth.currentUser!.uid)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  report(id, "Beat");
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.report,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Report"),
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
                          numberFormat(plays),
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
                                    producer: producer,
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
                                numberFormat(downloads),
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
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            Text(
                              numberFormat(likes),
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
}
