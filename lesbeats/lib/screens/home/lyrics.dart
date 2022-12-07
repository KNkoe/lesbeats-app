import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../widgets/animation.dart';

class MyLyricsScreen extends StatefulWidget {
  const MyLyricsScreen({super.key});

  @override
  State<MyLyricsScreen> createState() => _MyLyricsScreenState();
}

class _MyLyricsScreenState extends State<MyLyricsScreen> {
  final List<String> artists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous",
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

  final List<String> topArtists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

  // bool _preview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add))
        ],
      ),
      body: Container(
        color: Theme.of(context).cardColor,
        height: Get.height,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                "Top Songwriters",
                style: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: Get.height * 0.2,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: topArtists
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
                              delay: delay(topArtists.indexOf(artist)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    height: 90,
                                    width: 90,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'assets/images/rnb.jpg'))),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          artist,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      if (topArtists.indexOf(artist) == 0)
                                        const Icon(
                                          Icons.verified,
                                          color: Colors.green,
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
            Expanded(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      child: Card(
                        color: Theme.of(context).backgroundColor,
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        minRadius: 20,
                                        backgroundImage: AssetImage(
                                            "assets/images/house.jpg"),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Sunshine",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            artists[index],
                                            style: const TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Posted ${DateTime.now().toString().split(" ")[0]}",
                                        style: const TextStyle(
                                            color: Colors.black38),
                                      ),
                                      PopupMenuButton(
                                          icon: const Icon(
                                            Icons.more_vert,
                                          ),
                                          itemBuilder: ((context) => [
                                                PopupMenuItem(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: const [
                                                    Icon(
                                                      Icons.chat,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Chat"),
                                                  ],
                                                )),
                                                PopupMenuItem(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: const [
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Buy"),
                                                  ],
                                                )),
                                                const PopupMenuItem(
                                                    height: 2,
                                                    child: Divider()),
                                                PopupMenuItem(
                                                    child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.share,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Share"),
                                                  ],
                                                )),
                                                PopupMenuItem(
                                                    child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.report,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Report"),
                                                  ],
                                                )),
                                              ])),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                height: Get.height * 0.3,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 10, 10),
                                child: const Text(
                                  "Verse 1\nEverything is soo different now\nI never thought I'd be the one to say that I'm in love\nI never caught myself obessing over one girl\nAnd I promise its the best feeling I ever had\nI spend most night just thinking about it\nGirl got me crazy I only hear this when I read about it\nIt's soo much like in pradise,\nI mean everytime I wake up next to her I can't believe my eyes,\nVerse 1\nEverything is soo different now\nI never thought I'd be the one to say that I'm in love\nI never caught myself obessing over one girl\nAnd I promise its the best feeling I ever had\nI spend most night just thinking about it\nGirl got me crazy I only hear this when I read about it\nIt's soo much like in pradise,\nI mean everytime I wake up next to her I can't believe my eyes",
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.thumb_up,
                                              color: Colors.black38,
                                            ))
                                      ],
                                    ),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            fixedSize:
                                                const Size.fromWidth(100),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        onPressed: () {},
                                        child: const Text("R100")),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: artists.length),
            )
          ],
        ),
      ),
    );
  }
}
