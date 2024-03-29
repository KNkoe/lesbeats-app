import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/drawer/genre/tracks.dart';

import '../../../../main.dart';

class MyGenre extends StatefulWidget {
  const MyGenre({super.key});

  @override
  State<MyGenre> createState() => _MyGenreState();
}

class _MyGenreState extends State<MyGenre> {
  late final Stream<QuerySnapshot> _genreStream;

  @override
  void initState() {
    _genreStream = db.collection('genres').orderBy("title").snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Genres",
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.titleLarge!.color,
            )),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _genreStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor));
            } else if (snapshot.hasData) {
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: ((context, index) => OpenContainer(
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    closedBuilder: ((context, action) => Container(
                          height: 30,
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 3),
                                  spreadRadius: -2,
                                  blurRadius: 12,
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                )
                              ],
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.docs[index]["title"],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Transform.rotate(
                                    angle: 0.2,
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 3),
                                              spreadRadius: -2,
                                              blurRadius: 10,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                            )
                                          ],
                                          image: const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "assets/icon/logo.png")),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                    openBuilder: ((context, action) {
                      return MyTracks(
                          genre: snapshot.data!.docs[index]["title"]);
                    }))),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              );
            }
            return const SizedBox();
          }),
    );
  }
}
