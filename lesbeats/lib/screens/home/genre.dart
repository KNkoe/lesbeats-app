import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lesbeats/widgets/animation.dart';
import 'package:lesbeats/widgets/responsive.dart';

import '../../main.dart';

class MyGenre extends StatefulWidget {
  const MyGenre({super.key});

  @override
  State<MyGenre> createState() => _MyGenreState();
}

class _MyGenreState extends State<MyGenre> {
  late final Stream<QuerySnapshot> _genreStream;

  @override
  void initState() {
    _genreStream = db.collection('genres').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Genres"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).backgroundColor),
          child: StreamBuilder<QuerySnapshot>(
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
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {},
                          child: Animate(
                            effects: const [FadeEffect(), ShimmerEffect()],
                            delay: genreDelay(index),
                            child: OpenContainer(
                                closedColor: Colors.transparent,
                                closedElevation: 0,
                                openElevation: 0,
                                closedBuilder: ((context, action) => Container(
                                      height: 30,
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      margin: const EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 3),
                                              spreadRadius: -2,
                                              blurRadius: 12,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.2),
                                            )
                                          ],
                                          color:
                                              Theme.of(context).indicatorColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]["title"],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.5),
                                                        )
                                                      ],
                                                      image: const DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              "assets/icon/logo.png")),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                openBuilder: ((context, action) =>
                                    Container())),
                          ),
                        )),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                  );
                }
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}
