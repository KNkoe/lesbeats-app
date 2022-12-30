import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/producers.dart';
import 'package:lesbeats/services/stream/audio_tile.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/decoration.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  late final Stream<QuerySnapshot> _trackStream;
  late final Stream<QuerySnapshot> _userStream;
  late final Stream<QuerySnapshot> _recentStream;

  final TextEditingController queryController = TextEditingController();
  String query = "";
  List<QueryDocumentSnapshot<Object?>> tracks = [];
  List<QueryDocumentSnapshot<Object?>> users = [];

  @override
  void initState() {
    super.initState();
    _trackStream = db.collection("tracks").snapshots();
    _userStream = db.collection("users").snapshots();
    _recentStream = db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("recent searches")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    queryController.dispose();
    tracks.clear();
    users.clear();
    super.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Search",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SizedBox(
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: queryController,
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  onEditingComplete: () {
                    db
                        .collection("users")
                        .doc(auth.currentUser!.uid)
                        .collection("recent searches")
                        .add({"query": query, "timestamp": DateTime.now()});
                  },
                  decoration: InputDecoration(
                      icon: const Iconify(Ri.search_2_line),
                      hintText: "Producers, artists or beats",
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 40,
                ),
                if (query.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: DefaultTabController(
                      length: 2,
                      child: TabBar(
                          onTap: (value) {
                            setState(() {
                              selectedIndex = value;
                            });
                          },
                          indicator: DotIndicator(
                              color: Theme.of(context).primaryColor, radius: 8),
                          tabs: [
                            Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Beats"),
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Producers",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                if (query.isEmpty)
                  Row(children: [
                    const Icon(Icons.refresh),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Recent searches",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ]),
                if (query.isEmpty)
                  StreamBuilder(
                      stream: _recentStream,
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }

                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.size,
                              itemBuilder: ((context, index) {
                                return ListTile(
                                  onTap: () {
                                    setState(() {
                                      query =
                                          snapshot.data!.docs[index]["query"];
                                    });
                                  },
                                  title:
                                      Text(snapshot.data!.docs[index]["query"]),
                                  trailing: IconButton(
                                      onPressed: () {
                                        snapshot.data!.docs[index].reference
                                            .delete();
                                      },
                                      icon: const Icon(Icons.clear)),
                                );
                              }),
                            ),
                          );
                        }

                        return const SizedBox();
                      })),
                if (query.isNotEmpty)
                  const SizedBox(
                    height: 20,
                  ),
                if (query.isNotEmpty && selectedIndex == 0)
                  StreamBuilder<QuerySnapshot>(
                      stream: _trackStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Lottie.network(
                                "https://assets5.lottiefiles.com/packages/lf20_xbf1be8x.json"),
                          );
                        }
                        if (snapshot.hasData) {
                          tracks = snapshot.data!.docs.toList();

                          final trackMap = tracks.asMap();

                          tracks = tracks
                              .where((track) => track
                                  .get("title")
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();

                          if (tracks.isEmpty) {
                            return Center(
                              child: LottieBuilder.network(
                                  "https://assets1.lottiefiles.com/packages/lf20_dmw3t0vg.json"),
                            );
                          }

                          return Expanded(
                              child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: tracks.length,
                            itemBuilder: (context, index) {
                              int indexoftrack = trackMap.keys.firstWhere(
                                (element) => tracks[index] == trackMap[element],
                              );

                              return MyAudioTile(
                                snapshot: snapshot,
                                index: indexoftrack,
                                isProfileOpened: false,
                              );
                            },
                          ));
                        }

                        return const SizedBox();
                      }),
                if (query.isNotEmpty && selectedIndex == 1)
                  StreamBuilder<QuerySnapshot>(
                      stream: _userStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Lottie.network(
                                "https://assets5.lottiefiles.com/packages/lf20_xbf1be8x.json"),
                          );
                        }
                        if (snapshot.hasData) {
                          users = snapshot.data!.docs.toList();

                          final userMap = users.asMap();

                          users = users
                              .where((user) => user
                                  .get("username")
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();

                          if (users.isEmpty) {
                            return Center(
                              child: LottieBuilder.network(
                                  "https://assets1.lottiefiles.com/packages/lf20_dmw3t0vg.json"),
                            );
                          }

                          return Expanded(
                              child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              int indexofUser = userMap.keys.firstWhere(
                                (element) => users[index] == userMap[element],
                              );

                              debugPrint(
                                  "UID: ${snapshot.data!.docs[indexofUser]}");
                              return MyProducerTile(
                                  doc: snapshot.data!.docs[indexofUser]);
                            },
                          ));
                        }

                        return const SizedBox();
                      })
              ],
            ),
          ),
        ));
  }
}
