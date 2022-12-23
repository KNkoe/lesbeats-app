import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/services/stream/audio_stream.dart';

class MyTrendingPage extends StatefulWidget {
  const MyTrendingPage({super.key});

  @override
  State<MyTrendingPage> createState() => _MyTrendingPageState();
}

class _MyTrendingPageState extends State<MyTrendingPage> {
  late final Stream<QuerySnapshot> _trackStream;
  late final Stream<QuerySnapshot> _trendingStream;

  @override
  void initState() {
    super.initState();
    _trackStream = db.collection("tracks").snapshots();

    _trackStream.listen((element) async {
      for (var element in element.docs) {
        int plays = 0;
        await element.reference.collection("plays").get().then((value) {
          plays += value.size;
        });

        element.reference.set({"plays": plays}, SetOptions(merge: true));

        debugPrint("PLAYS: ${plays.toString()}");
      }
    });

    _trendingStream =
        db.collection("tracks").orderBy("plays", descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Trending",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6!.color,
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
        body: MyAudioStream(
          stream: _trendingStream,
        ));
  }
}
