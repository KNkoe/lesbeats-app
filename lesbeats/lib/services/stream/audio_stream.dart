import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/services/stream/audio_tile.dart';
import 'package:lottie/lottie.dart';

class MyAudioStream extends StatefulWidget {
  const MyAudioStream(
      {Key? key, required this.stream, this.isProfileOpened = false})
      : super(key: key);

  final Stream<QuerySnapshot> stream;
  final bool isProfileOpened;

  @override
  State<MyAudioStream> createState() => _MyAudioStreamState();
}

class _MyAudioStreamState extends State<MyAudioStream> {
  @override
  void initState() {
    super.initState();
    widget.stream.listen((element) async {
      for (var element in element.docs) {
        try {
          if (element.id == element.get("id")) {
            int downloads = 0;
            int likes = 0;
            int plays = 0;

            await element.reference.collection("downloads").get().then((value) {
              downloads += value.size;
            });

            await element.reference.collection("likes").get().then((value) {
              likes += value.size;
            });

            await element.reference.collection("plays").get().then((value) {
              plays += value.size;
            });

            element.reference.set(
                {"downloads": downloads, "likes": likes, "plays": plays},
                SetOptions(merge: true));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.stream,
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
            if ((snapshot.data!.size == 0)) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                      "https://assets1.lottiefiles.com/private_files/lf30_e3pteeho.json",
                    ),
                    const Text("Empty")
                  ],
                ),
              );
            } else {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.size,
                  itemBuilder: ((context, index) {
                    return MyAudioTile(
                        key: UniqueKey(),
                        snapshot: snapshot,
                        index: index,
                        isProfileOpened: widget.isProfileOpened);
                  }));
            }
          }

          return const Center(child: Text("Something went wrong!"));
        });
  }
}
