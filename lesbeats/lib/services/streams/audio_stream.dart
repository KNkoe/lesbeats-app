import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../player/player.dart';
import '../../screens/profile/profile.dart';

StreamBuilder<QuerySnapshot> getStream(stream) {
  return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        if (snapshot.hasData) {
          if ((snapshot.data!.size == 0)) {
            return Center(
              child: SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.sentiment_dissatisfied_rounded,
                      color: Colors.black12,
                      size: 34,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Empty",
                      style: TextStyle(color: Colors.black38),
                    )
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: ((context, index) {
                  final date = snapshot.data!.docs[index]["uploadedAt"];
                  final cover = snapshot.data!.docs[index]["cover"];
                  final path = snapshot.data!.docs[index]["path"];
                  final title = snapshot.data!.docs[index]["title"];
                  final price = snapshot.data!.docs[index]["price"];
                  final feature = snapshot.data!.docs[index]["feature"];
                  final genre = snapshot.data!.docs[index]["genre"];
                  final artistId = snapshot.data!.docs[index]["artistId"];
                  final id = snapshot.data!.docs[index]["id"];

                  final Stream<QuerySnapshot> downloadStream = db
                      .collection("interactions")
                      .doc(id)
                      .collection("downloads")
                      .snapshots();
                  final Stream<QuerySnapshot> playStream = db
                      .collection("interactions")
                      .doc(id)
                      .collection("plays")
                      .snapshots();
                  final Stream<QuerySnapshot> salesStream = db
                      .collection("interactions")
                      .doc(id)
                      .collection("sales")
                      .snapshots();
                  final Stream<QuerySnapshot> likeStream = db
                      .collection("interactions")
                      .doc(id)
                      .collection("likes")
                      .snapshots();
                  final Stream<DocumentSnapshot> artistStream =
                      db.collection("users").doc(artistId).snapshots();

                  return StreamBuilder5<QuerySnapshot, QuerySnapshot,
                          QuerySnapshot, QuerySnapshot, DocumentSnapshot>(
                      streams: StreamTuple5(salesStream, playStream,
                          downloadStream, likeStream, artistStream),
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

                        if (snapshot.snapshot1.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.snapshot2.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.snapshot3.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.snapshot4.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.snapshot5.connectionState ==
                                ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                        color: Colors.black12,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    height: 30,
                                    width: screenSize(context).width * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )
                                ],
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
                                ListTile(
                                  onTap: () {
                                    db
                                        .collection("interactions")
                                        .doc(id)
                                        .collection("plays")
                                        .doc(auth.currentUser!.uid)
                                        .set(play);
                                    playOnline(context, path, tags);
                                  },
                                  contentPadding: const EdgeInsets.all(0),
                                  minVerticalPadding: 20,
                                  leading: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholder:
                                              "assets/images/loading.gif",
                                          image: cover)),
                                  title: Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                  decoration: snapshot.snapshot1
                                                              .data!.size >
                                                          0
                                                      ? TextDecoration
                                                          .lineThrough
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
                                          closedColor: Colors.transparent,
                                          closedBuilder: ((context, action) =>
                                              Text(
                                                feature.toString().isEmpty
                                                    ? snapshot.snapshot5
                                                        .data!["username"]
                                                    : "${snapshot.snapshot5.data!["username"]} ft $feature",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )),
                                          openBuilder: (context, action) =>
                                              MyProfilePage(artistId),
                                        ),
                                        const Text(" | "),
                                        Text("$genre")
                                      ],
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                      itemBuilder: ((context) => [
                                            PopupMenuItem(
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
                                            PopupMenuItem(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${DateTime.now().difference(date.toDate()).inDays} days ago",
                                        style: const TextStyle(
                                            color: Colors.black45),
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
                                              snapshot.snapshot2.data!.size
                                                  .toString(),
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
                                              snapshot.snapshot3.data!.size
                                                  .toString(),
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
                                              Icons.favorite,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              snapshot.snapshot4.data!.size
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
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
                }));
          }
        }

        return const Center(child: Text("Something went wrong!"));
      });
}
