import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/stream/audio_stream.dart';

class MyTracks extends StatefulWidget {
  const MyTracks({super.key, this.genre = "", this.folder = "", this.uid = ""});
  final String genre;
  final String folder;
  final String uid;
  @override
  State<MyTracks> createState() => _MyTracksState();
}

class _MyTracksState extends State<MyTracks> {
  late Stream<QuerySnapshot> _audioStream;

  @override
  void initState() {
    super.initState();
    if (widget.genre.isNotEmpty) {
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

    if (widget.folder.isNotEmpty) {
      _audioStream = widget.uid == ''
          ? db
              .collection("tracks")
              .where("folder", isEqualTo: widget.folder)
              .orderBy("uploadedAt", descending: true)
              .snapshots()
          : db
              .collection("tracks")
              .where("artistId", isEqualTo: widget.uid)
              .where("folder", isEqualTo: widget.folder)
              .orderBy("uploadedAt", descending: true)
              .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.genre.isNotEmpty ? widget.genre : widget.folder,
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
      ),
      body: MyAudioStream(stream: _audioStream),
    );
  }
}
