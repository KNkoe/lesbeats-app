import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';

import '../../services/player/player.dart';
import '../decoration.dart';
import '../responsive.dart';
import 'checkout.dart';
import 'edit.dart';
import 'follow.dart';
import 'like.dart';
import 'report.dart';
import '../../main.dart';
import '../../screens/home/profile/profile.dart';
import 'delete.dart';
import 'download.dart';
import 'move.dart';

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
  String producer = "";
  late bool sold;
  String purchasedBy = "";

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
      producer = widget.snapshot.data!.docs[widget.index]["producer"];
      sold = widget.snapshot.data!.docs[widget.index]["sold"];

      if (sold) {
        purchasedBy = widget.snapshot.data!.docs[widget.index]["purchasedBy"];
      }
    } catch (e) {
      debugPrint(e.toString());
    }

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

    checkIfLiked(id);
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
        padding: const EdgeInsets.only(left: 5, bottom: 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: Container(
                  height: 70,
                  width: 70,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4)),
                  clipBehavior: Clip.hardEdge,
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: "assets/images/cover.jpg",
                    image: cover,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image_outlined),
                  )),
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
                        if (price == 0) {
                          showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              builder: ((context) => BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: AlertDialog(
                                      title: Text(
                                        "This beat is free and not available for purchase. You may download this beat if the producer enabled download for this beat.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        OutlinedButton(
                                            style: cancelButtonStyle,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Close"))
                                      ],
                                    ),
                                  )));
                        }
                        if (sold) {
                          showDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              builder: ((context) => BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: AlertDialog(
                                      title: Text(
                                        "This beat has already been sold to someone else",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        OutlinedButton(
                                            style: cancelButtonStyle,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Close"))
                                      ],
                                    ),
                                  )));
                        }

                        if (!sold && price != 0) {
                          showModalBottomSheet(
                              context: context,
                              builder: ((context) => Checkout(
                                    id: id,
                                    price: price,
                                    producer: producer,
                                    producerID: artistId,
                                    title: title,
                                  )));
                        }
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
                            price == 0 ? "Free" : "R ${price.round()}",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: sold ? Colors.red : Colors.black87,
                                    decoration: sold
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              subtitle: Row(
                children: [
                  OpenContainer(
                    closedElevation: 0,
                    tappable: !widget.isProfileOpened,
                    closedColor: Colors.transparent,
                    closedBuilder: ((context, action) => Text(
                          feature.toString().isEmpty
                              ? producer
                              : "$producer ft $feature",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                    openBuilder: (context, action) => MyProfilePage(artistId),
                  ),
                  Text(
                    " | $genre",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                ],
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
                        if (download || (purchasedBy == auth.currentUser!.uid))
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
                        if (artistId != auth.currentUser!.uid &&
                            price != 0 &&
                            !sold)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(
                                    Duration.zero,
                                    () => showModalBottomSheet(
                                        context: context,
                                        builder: ((context) => Checkout(
                                              id: id,
                                              title: title,
                                              price: price,
                                              producer: producer,
                                              producerID: artistId,
                                            ))));
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
                        PopupMenuItem(
                            onTap: () {
                              if (liked) {
                                unlikeTrack(id);

                                checkIfLiked(id);
                              } else {
                                likeTrack(id);
                                checkIfLiked(id);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  liked ? Icons.thumb_down : Icons.thumb_up,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(liked ? "Unlike" : "Like"),
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
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
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

                        PopupMenuItem(
                            height: 2,
                            child: SizedBox(
                                width: screenSize(context).width * 0.4,
                                child: const Divider())),
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
                        if (artistId == auth.currentUser!.uid)
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  moveTracks(context, id);
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Move"),
                                ],
                              )),

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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 10),
            //       child: Text(
            //         timeago.format(timeAgo),
            //         style: Theme.of(context).textTheme.bodyText2,
            //       ),
            //     ),
            //     const SizedBox(),
            //     Row(
            //       children: [
            //         Row(
            //           children: [
            //             const Icon(
            //               Icons.play_arrow,
            //               size: 18,
            //               color: Colors.grey,
            //             ),
            //             Text(
            //               numberFormat(plays),
            //               style: const TextStyle(
            //                 color: Colors.grey,
            //               ),
            //             )
            //           ],
            //         ),
            //         if (download)
            //           const SizedBox(
            //             width: 20,
            //           ),
            //         if (download)
            //           GestureDetector(
            //             onTap: () {
            //               showDialog(
            //                   context: context,
            //                   barrierColor: Colors.transparent,
            //                   builder: ((context) {
            //                     return MyDownload(
            //                         id: id,
            //                         title: title,
            //                         producerId: artistId,
            //                         producer: producer,
            //                         downloadUrl: path);
            //                   }));
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Row(
            //                 children: [
            //                   const Icon(
            //                     Icons.download_rounded,
            //                     size: 18,
            //                     color: Colors.grey,
            //                   ),
            //                   Text(
            //                     numberFormat(downloads),
            //                     style: const TextStyle(
            //                       color: Colors.grey,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         const SizedBox(
            //           width: 20,
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             if (!liked) {
            //               likeTrack(id);

            //               setState(() {
            //                 liked = true;
            //               });
            //             } else {
            //               unlikeTrack(id);

            //               setState(() {
            //                 liked = false;
            //               });
            //             }
            //           },
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Row(
            //               children: [
            //                 Icon(
            //                   Icons.favorite,
            //                   size: 18,
            //                   color: liked
            //                       ? Theme.of(context).primaryColor
            //                       : Colors.grey,
            //                 ),
            //                 Text(
            //                   numberFormat(likes),
            //                   style: const TextStyle(
            //                     color: Colors.grey,
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //         const SizedBox(
            //           width: 20,
            //         ),
            //       ],
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
