// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/upload/upload.dart';
import 'package:lesbeats/screens/player/player.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/widgets/responsive.dart';

class MySales extends StatefulWidget {
  const MySales({super.key});

  @override
  State<MySales> createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  late final Stream<QuerySnapshot> _audioStream;

  @override
  void initState() {
    super.initState();
    _audioStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: auth.currentUser!.uid)
        .orderBy("uploadedAt")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    backgroundColor: Theme.of(context).backgroundColor),
                onPressed: () {
                  showUpload(context);
                },
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.black54),
                )),
          )
        ],
      ),
      body: Container(
          color: Theme.of(context).primaryColor,
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Theme.of(context).backgroundColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Uploads",
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: Theme.of(context).primaryColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _audioStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        if ((snapshot.data!.size == 0)) {
                          return Expanded(
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
                                  "No uploads",
                                  style: TextStyle(color: Colors.black38),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.size,
                                reverse: true,
                                itemBuilder: ((context, index) {
                                  final date =
                                      snapshot.data!.docs[index]["uploadedAt"];
                                  final cover =
                                      snapshot.data!.docs[index]["cover"];
                                  final path =
                                      snapshot.data!.docs[index]["path"];
                                  final title =
                                      snapshot.data!.docs[index]["title"];
                                  final price =
                                      snapshot.data!.docs[index]["price"];
                                  final artist =
                                      snapshot.data!.docs[index]["artist"];
                                  final genre =
                                      snapshot.data!.docs[index]["genre"];
                                  final artistId =
                                      snapshot.data!.docs[index]["artistId"];

                                  final Map<String, String> tags = {
                                    "title": title,
                                    "cover": cover,
                                    "artist": artist,
                                    "artistId": artistId
                                  };

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            playOnline(context, path, tags);
                                          },
                                          contentPadding:
                                              const EdgeInsets.all(0),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                OpenContainer(
                                                  closedElevation: 0,
                                                  closedColor:
                                                      Colors.transparent,
                                                  closedBuilder:
                                                      ((context, action) =>
                                                          Text(
                                                            "${artist}",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                          )),
                                                  openBuilder: (context,
                                                          action) =>
                                                      MyProfilePage(artistId),
                                                ),
                                                const Text(" | "),
                                                Text("${genre}")
                                              ],
                                            ),
                                          ),
                                          trailing: PopupMenuButton(
                                              itemBuilder: ((context) => [
                                                    PopupMenuItem(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: const [
                                                        Icon(
                                                            Icons.check_circle),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("Buy"),
                                                      ],
                                                    )),
                                                    const PopupMenuItem(
                                                        height: 2,
                                                        child: Divider()),
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
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                "${DateTime.now().difference(date.toDate()).inDays} days ago",
                                                style: const TextStyle(
                                                    color: Colors.black45),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.play_arrow,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                      "34",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.download_rounded,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                      "34",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.favorite,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                      "34",
                                                      style: TextStyle(
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
                                })),
                          );
                        }
                      }

                      return const Center(child: Text("Something went wrong!"));
                    })
              ],
            ),
          )),
    );
  }
}
