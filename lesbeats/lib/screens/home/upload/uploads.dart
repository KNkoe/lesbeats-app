import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/home/upload/upload.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:lesbeats/widgets/track_stream.dart';

class MySales extends StatefulWidget {
  const MySales({super.key});

  @override
  State<MySales> createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  late final Stream<QuerySnapshot> _audioStream;
  late final Stream<QuerySnapshot> _interactionStream;

  @override
  void initState() {
    super.initState();
    _audioStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: auth.currentUser!.uid)
        .orderBy("uploadedAt", descending: true)
        .snapshots();

    _interactionStream = db.collection("interactions").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    backgroundColor: Theme.of(context).backgroundColor),
                onPressed: () {
                  showUpload(context);
                },
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.black54),
                )),
          )
        ],
      ),
      body: Container(
          color: Theme.of(context).primaryColor,
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Theme.of(context).backgroundColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Uploads",
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold)),
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
                Expanded(child: getStream(_audioStream, _interactionStream))
              ],
            ),
          )),
    );
  }
}
