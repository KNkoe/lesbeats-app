import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'package:lesbeats/widgets/theme.dart';

import '../../widgets/animation.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  final List<String> followedArtists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

  bool _viewAllArtists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Library"),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        height: Get.height,
        width: Get.width,
        child: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).backgroundColor),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Followed Artists",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _viewAllArtists = !_viewAllArtists;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _viewAllArtists
                              ? Text(
                                  "View less",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  "View more",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: followedArtists
                        .map((artist) => Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Animate(
                                  effects: const [
                                    FadeEffect(),
                                    SlideEffect(
                                        begin: Offset(1, 0), end: Offset(0, 0))
                                  ],
                                  delay: delay(followedArtists.indexOf(artist)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(colors: [
                                              Theme.of(context).canvasColor,
                                              Theme.of(context).primaryColor
                                            ])),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  width: 2),
                                              shape: BoxShape.circle,
                                              image: const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/images/artist.jpg'))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(artist),
                                          ),
                                          if (followedArtists.indexOf(artist) ==
                                              0)
                                            const Icon(
                                              Icons.verified,
                                              color: malachite,
                                              size: 18,
                                            )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recently played",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _viewAllArtists = !_viewAllArtists;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _viewAllArtists
                              ? Text(
                                  "View less",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  "View more",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: followedArtists
                        .map((artist) => Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Animate(
                                  effects: const [
                                    FadeEffect(),
                                    SlideEffect(
                                        begin: Offset(1, 0), end: Offset(0, 0))
                                  ],
                                  delay: delay(followedArtists.indexOf(artist)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, left: 10),
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/artist.jpg'))),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          artist,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              artist,
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Favourites",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _viewAllArtists = !_viewAllArtists;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _viewAllArtists
                              ? Text(
                                  "View less",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  "View more",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).primaryColor),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: SizedBox(
                    height: Get.height * 0.6,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: followedArtists
                          .map((artist) => Animate(
                                  effects: const [
                                    FadeEffect(),
                                  ],
                                  delay: delay(followedArtists.indexOf(artist)),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    minVerticalPadding: 30,
                                    leading: Container(
                                      height: 70,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/artist.jpg"))),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.play_circle,
                                            color: Colors.white,
                                          )),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(artist),
                                        const Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.red,
                                        )
                                      ],
                                    ),
                                    subtitle: const Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text("Artist"),
                                    ),
                                  )))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
