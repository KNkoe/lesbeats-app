import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';

import '../../services/stream/audio_stream.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  late final Stream<QuerySnapshot> _audioStream;

  @override
  void initState() {
    super.initState();
    _audioStream = db
        .collection("tracks")
        .orderBy("uploadedAt", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Activity Feed",
                style: TextStyle(
                    color: Colors.black26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(child: MyAudioStream(stream: _audioStream)),
      ],
    );
  }
}
