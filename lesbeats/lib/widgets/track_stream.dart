import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../screens/player/player.dart';
import '../screens/profile/profile.dart';

StreamBuilder2<QuerySnapshot, QuerySnapshot> getStream(stream1, stream2) {
  return StreamBuilder2<QuerySnapshot, QuerySnapshot>(
      streams: StreamTuple2(stream1, stream2),
      builder: (context, snapshot) {
        if (snapshot.snapshot1.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (snapshot.snapshot1.hasData) {
          if ((snapshot.snapshot1.data!.size == 0)) {
            return Column(
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
            );
          } else {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.snapshot1.data!.size,
                itemBuilder: ((context, index) {
                  final date =
                      snapshot.snapshot1.data!.docs[index]["uploadedAt"];
                  final cover = snapshot.snapshot1.data!.docs[index]["cover"];
                  final path = snapshot.snapshot1.data!.docs[index]["path"];
                  final title = snapshot.snapshot1.data!.docs[index]["title"];
                  final price = snapshot.snapshot1.data!.docs[index]["price"];
                  final artist = snapshot.snapshot1.data!.docs[index]["artist"];
                  final genre = snapshot.snapshot1.data!.docs[index]["genre"];
                  final artistId =
                      snapshot.snapshot1.data!.docs[index]["artistId"];

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
                                  closedBuilder: ((context, action) => Text(
                                        "$artist",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
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
                }));
          }
        }

        return const Center(child: Text("Something went wrong!"));
      });
}
