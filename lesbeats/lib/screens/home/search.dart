import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/services/stream/audio_tile.dart';
import 'package:lottie/lottie.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  late final Stream<QuerySnapshot> _trackStream;
  final TextEditingController queryController = TextEditingController();
  String query = "";

  @override
  void initState() {
    super.initState();
    _trackStream = db.collection("tracks").snapshots();
  }

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
                  decoration: InputDecoration(
                      icon: const Iconify(Ri.search_2_line),
                      hintText: "Artists, beats, genre or lyrics",
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30))),
                ),
                const SizedBox(
                  height: 40,
                ),
                if (query.isNotEmpty)
                  StreamBuilder<QuerySnapshot>(
                      stream: _trackStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<QueryDocumentSnapshot<Object?>> tracks =
                              snapshot.data!.docs.toList();

                          final trackMap = tracks.asMap();

                          tracks = tracks
                              .where((s) => s
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

                              debugPrint(
                                  "INDEX OF TRACK: $indexoftrack \nINDEX: $index");
                              return MyAudioTile(
                                snapshot: snapshot,
                                index: indexoftrack,
                                isProfileOpened: false,
                              );
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
