import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/stream/audio_stream.dart';

class MyTracks extends StatefulWidget {
  const MyTracks({super.key, required this.genre, this.uid = ""});
  final String genre;
  final String uid;
  @override
  State<MyTracks> createState() => _MyTracksState();
}

class _MyTracksState extends State<MyTracks> {
  late Stream<QuerySnapshot> _audioStream;

  @override
  void initState() {
    super.initState();
    _audioStream = widget.uid == ''
        ? db
            .collection("tracks")
            .where("genre", isEqualTo: widget.genre)
            .orderBy("uploadedAt", descending: true)
            .snapshots()
        : db
            .collection("tracks")
            .where("artistId", isEqualTo: widget.uid)
            .where("genre", isEqualTo: widget.genre)
            .orderBy("uploadedAt", descending: true)
            .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.genre,
          style: Theme.of(context).textTheme.headline6!,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.headline6!.color,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Theme.of(context).textTheme.headline6!.color,
              ))
        ],
      ),
      body: MyAudioStream(stream: _audioStream),
    );
  }
}
