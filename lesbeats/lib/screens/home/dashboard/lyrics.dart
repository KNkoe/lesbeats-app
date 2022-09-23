import 'package:flutter/material.dart';

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

  bool _preview = false;

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
                "Top Song-Writers",
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
                        Column(
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
                                      image:
                                          AssetImage('assets/images/rnb.jpg'))),
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
                      ],
                    ))
                .toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: _preview ? 400 : 200,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              const Text(
                                "Verse 1\nEverything is soo different now\nI never thought I'd be the one to say that I'm in love\nI never caught myself obessing over one girl\nAnd I promise its the best feeling I ever had\nI spend most night just thinking about it\nGirl got me crazy I only hear this when I read about it\nIt's soo much like in pradise,\nI mean everytime I wake up next to her I can't believe my eyes",
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 1,
                                        backgroundColor: Colors.black12,
                                        shape: const CircleBorder()),
                                    onPressed: () {
                                      setState(() {
                                        _preview = !_preview;
                                      });
                                    },
                                    child: Icon(_preview
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down)),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "54",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ElevatedButton.icon(
                                  icon: const Text(
                                    " R",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {},
                                  label: const Text("100")),
                            ),
                          ],
                        )
                      ],
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
