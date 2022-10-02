import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/wpf.dart';

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  final List<String> activities = [
    "Scandal",
    "Love affairs",
    "Soon",
    "How about that",
    "Vicious"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: activities
          .map((e) => Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 10),
                    minVerticalPadding: 30,
                    leading: Container(
                      height: 70,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/artist.jpg"))),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_circle,
                            color: Colors.white,
                          )),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Row(
                          children: const [
                            Iconify(
                              Wpf.shopping_bag,
                              size: 20,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text("R250")
                          ],
                        )
                      ],
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text("Artist | genre"),
                    ),
                    trailing: PopupMenuButton(
                        itemBuilder: ((context) => [
                              PopupMenuItem(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(Icons.download),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Download"),
                                ],
                              )),
                              PopupMenuItem(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(Icons.check_circle),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Buy"),
                                ],
                              )),
                              const PopupMenuItem(height: 2, child: Divider()),
                              PopupMenuItem(
                                  child: Row(
                                children: const [
                                  Icon(Icons.share),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Share"),
                                ],
                              )),
                              PopupMenuItem(
                                  child: Row(
                                children: const [
                                  Icon(Icons.report),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Report"),
                                ],
                              )),
                            ])),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          DateTime.now().toString().split(" ")[0],
                          style: const TextStyle(color: Colors.black45),
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.play_arrow,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                "34",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.download_rounded,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                "34",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.favorite,
                                size: 18,
                                color: Colors.grey,
                              ),
                              Text(
                                "34",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider()
                ],
              ))
          .toList(),
    );
  }
}
