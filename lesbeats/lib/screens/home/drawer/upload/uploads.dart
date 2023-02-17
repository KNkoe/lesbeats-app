import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/drawer/upload/upload.dart';
import 'package:lesbeats/services/stream/audio_stream.dart';
import 'package:lesbeats/widgets/decoration.dart';

class MyUploads extends StatefulWidget {
  const MyUploads({super.key});

  @override
  State<MyUploads> createState() => _MyUploadsState();
}

class _MyUploadsState extends State<MyUploads> {
  late final Stream<QuerySnapshot> _audioStream;

  @override
  void initState() {
    super.initState();
    _audioStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: auth.currentUser!.uid)
        .orderBy("uploadedAt", descending: true)
        .snapshots();

    _audioStream.listen((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.headline6!.color,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: cancelButtonStyle,
                onPressed: () {
                  showUpload(context);
                },
                child: const Text(
                  "Upload",
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Uploads",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: Theme.of(context).primaryColor,
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: MyAudioStream(stream: _audioStream))
          ],
        ),
      ),
    );
  }
}
