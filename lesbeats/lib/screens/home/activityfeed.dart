import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';

import '../../services/streams/audio.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  late final Stream<QuerySnapshot> _audioStream;
  late final Stream<QuerySnapshot> _interactionStream;

  @override
  void initState() {
    super.initState();
    _audioStream = db
        .collection("tracks")
        .orderBy("uploadedAt", descending: true)
        .snapshots();
    _interactionStream = db.collection("interactions").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return getStream(_audioStream, _interactionStream);
  }
}
