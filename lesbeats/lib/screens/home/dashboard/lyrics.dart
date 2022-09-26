import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../widgets/animation.dart';
import '../../../widgets/theme.dart';

class MyLyrcisScreen extends StatefulWidget {
  const MyLyrcisScreen({super.key});

  @override
  State<MyLyrcisScreen> createState() => _MyLyrcisScreenState();
}

class _MyLyrcisScreenState extends State<MyLyrcisScreen> {
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

  bool _viewAllArtists = false;
  final PageController _pageController = PageController();

  // bool _preview = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Songwriters",
                style: TextStyle(color: Colors.grey),
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
            children: topArtists
                .map((artist) => Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Animate(
                          effects: const [
                            FadeEffect(),
                            SlideEffect(begin: Offset(1, 0), end: Offset(0, 0))
                          ],
                          delay: delay(topArtists.indexOf(artist)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, left: 10),
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
                                    child: Text(artist),
                                  ),
                                  if (topArtists.indexOf(artist) == 0)
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
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(30),
                  child: Card(
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    minRadius: 20,
                                    backgroundImage:
                                        AssetImage("assets/images/house.jpg"),
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
                                        style: TextStyle(fontSize: 18),
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
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  PopupMenuButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.black54,
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
                                                height: 2, child: Divider()),
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
                            height: 200,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                            child: const Text(
                              "Verse 1\nEverything is soo different now\nI never thought I'd be the one to say that I'm in love\nI never caught myself obessing over one girl\nAnd I promise its the best feeling I ever had\nI spend most night just thinking about it\nGirl got me crazy I only hear this when I read about it\nIt's soo much like in pradise,\nI mean everytime I wake up next to her I can't believe my eyes",
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (index != 0)
                                  ? IconButton(
                                      onPressed: () {
                                        _pageController.previousPage(
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Colors.black26,
                                      ))
                                  : const SizedBox(
                                      width: 20,
                                    ),
                              OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {},
                                  child: const Text("R100")),
                              IconButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.ease);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black26,
                                  ))
                            ],
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
    );
  }
}
