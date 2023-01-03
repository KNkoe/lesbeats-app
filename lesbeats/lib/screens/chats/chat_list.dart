import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/load.dart';

import 'chat.dart';

class MyChatList extends StatefulWidget {
  const MyChatList({super.key});

  @override
  State<MyChatList> createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
  late final Stream<QuerySnapshot> messages;

  @override
  void initState() {
    messages = db
        .collection("messages")
        .where("participants", arrayContains: auth.currentUser!.uid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Inbox",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).primaryIconTheme.color),
          toolbarHeight: 50,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              children: [
                const Divider(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 70,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Iconify(
                            Bx.search,
                            color: Colors.black38,
                          ),
                        ),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        label: const Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.black38,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: messages,
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
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      String userId =
                          snapshot.data!.docs[index].id.split('+')[0] ==
                                  auth.currentUser!.uid
                              ? snapshot.data!.docs[index].id.split('+')[1]
                              : snapshot.data!.docs[index].id.split('+')[0];

                      return StreamBuilder<DocumentSnapshot>(
                          stream:
                              db.collection("users").doc(userId).snapshots(),
                          builder: (context, usersnapshot) {
                            if (usersnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ChatLoading();
                            }

                            if (usersnapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: OpenContainer(
                                    closedBuilder: ((context, action) => Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10, top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipOval(
                                                        child: FadeInImage.assetNetwork(
                                                            placeholder:
                                                                "assets/images/placeholder.jpg",
                                                            image: usersnapshot
                                                                .data!
                                                                .get(
                                                                    "photoUrl")),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10,
                                                                    top: 20),
                                                            child: Text(
                                                              usersnapshot.data!
                                                                  .get(
                                                                      "username"),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1,
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            height: 40,
                                                            child: const Text(
                                                              "The actual message send to this user",
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          child: Badge(
                                                            showBadge: false,
                                                            badgeColor: Theme
                                                                    .of(context)
                                                                .indicatorColor,
                                                            child: const Text(
                                                              "2",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                      const Text("15:09")
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    openBuilder: ((context, action) =>
                                        MyChat(userId: userId))),
                              );
                            }

                            return const SizedBox();
                          });
                    });
              }

              return const SizedBox();
            }));
  }
}
