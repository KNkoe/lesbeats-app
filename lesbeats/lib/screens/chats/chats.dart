import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<MyChatScreen> createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  List<String> messages = [
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous",
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "VicIouS"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inbox",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).primaryIconTheme.color),
        toolbarHeight: 50,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              const Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 70,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Iconify(
                          Bx.search,
                          color: Colors.black38,
                        ),
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      label: const Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.black38,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: messages
              .map((e) => OpenContainer(
                  closedBuilder: ((context, action) => Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      minRadius: 30,
                                      backgroundImage:
                                          AssetImage("assets/images/rnb.jpg"),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, top: 20),
                                          child: Text(
                                            e,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          height: 40,
                                          child: const Text(
                                            "The actual message send to this user",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        padding: const EdgeInsets.all(6),
                                        child: Badge(
                                          showBadge: false,
                                          badgeColor:
                                              Theme.of(context).indicatorColor,
                                          child: const Text(
                                            "2",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                    const Text("15:09")
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  openBuilder: ((context, action) => Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      minRadius: 30,
                                      backgroundImage:
                                          AssetImage("assets/images/rnb.jpg"),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, top: 20),
                                          child: Text(
                                            e,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          height: 40,
                                          child: const Text(
                                            "The actual message send to this user",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        padding: const EdgeInsets.all(6),
                                        child: Badge(
                                          showBadge: false,
                                          badgeColor:
                                              Theme.of(context).indicatorColor,
                                          child: const Text(
                                            "2",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                    const Text("15:09")
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Divider()
                        ],
                      ))))
              .toList(),
        ),
      ),
    );
  }
}
