import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/services/streams/audio_stream.dart';

class MyBeats extends StatefulWidget {
  const MyBeats({super.key, required this.uid, required this.stream});
  final String uid;
  final Stream<QuerySnapshot> stream;

  @override
  State<MyBeats> createState() => _MyBeatsState();
}

class _MyBeatsState extends State<MyBeats> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: getStream(widget.stream));
  }
}
