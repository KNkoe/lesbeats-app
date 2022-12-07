import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:lesbeats/services/streams/audio_tile.dart';
import 'package:iconify_flutter/icons/uil.dart';

class MyAudioStream extends StatelessWidget {
  const MyAudioStream(
      {Key? key, required this.stream, this.isProfileOpened = false})
      : super(key: key);

  final Stream<QuerySnapshot> stream;
  final bool isProfileOpened;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasData) {
            if ((snapshot.data!.size == 0)) {
              return Center(
                child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Iconify(Uil.cloud_exclamation,
                          color: Colors.black38, size: 24),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Empty",
                        style: TextStyle(color: Colors.black38),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.size,
                  itemBuilder: ((context, index) {
                    return MyAudioTile(
                        snapshot: snapshot,
                        index: index,
                        isProfileOpened: isProfileOpened);
                  }));
            }
          }

          return const Center(child: Text("Something went wrong!"));
        });
  }
}
