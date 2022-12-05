import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/widgets/responsive.dart';

import 'package:lesbeats/widgets/theme.dart';

import 'activityfeed.dart';
import 'artists.dart';
import 'drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    _usersStream = db.collection('users').snapshots();
    super.initState();
  }

  bool _viewAllArtists = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: Iconify(
              Jam.menu,
              size: 32,
              color: Theme.of(context).backgroundColor,
            )),
        title: const Image(
            height: 250,
            width: 130,
            image: AssetImage("assets/images/lesbeats.png")),
        actions: [
          IconButton(
              onPressed: () {
                showBottomSheet(
                    context: context, builder: (context) => Container());
              },
              icon: Badge(
                  badgeColor: Theme.of(context).indicatorColor,
                  badgeContent: const Text(
                    "4",
                    style: TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.notifications)))
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Theme.of(context).backgroundColor),
            child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Top Artists",
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold),
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
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      : Text(
                                          "View more",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Theme.of(context)
                                                  .primaryColor),
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
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index) {
                                  if (snapshot.data!.docs[index]["uid"] !=
                                      auth.currentUser!.uid) {
                                    if (index <= 10) {
                                      return OpenContainer(
                                          openElevation: 0,
                                          closedElevation: 0,
                                          closedColor: Colors.transparent,
                                          transitionDuration:
                                              const Duration(milliseconds: 100),
                                          closedBuilder: ((context, action) =>
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient:
                                                                LinearGradient(
                                                                    stops: const [
                                                                  0.7,
                                                                  0.3
                                                                ],
                                                                    colors: [
                                                                  Theme.of(
                                                                          context)
                                                                      .canvasColor,
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                ])),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10,
                                                                  left: 10),
                                                          height: 90,
                                                          width: 90,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .backgroundColor,
                                                            border: Border.all(
                                                                color: Theme.of(
                                                                        context)
                                                                    .backgroundColor,
                                                                width: 2),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: ClipOval(
                                                            child: FadeInImage.assetNetwork(
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder:
                                                                    "assets/images/placeholder.jpg",
                                                                image: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    [
                                                                    "photoUrl"]),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["username"],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          if (snapshot.data!
                                                                  .docs[index]
                                                              ["isVerified"])
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
                                              )),
                                          openBuilder: ((context, action) =>
                                              MyProfilePage(snapshot
                                                  .data!.docs[index]["uid"])));
                                    }
                                  }
                                  return const SizedBox();
                                })),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _viewAllArtists ? "Artists" : "Activity Feed",
                                style: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold),
                              ),
                              if (!_viewAllArtists)
                                IconButton(
                                    onPressed: () {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    },
                                    icon: Icon(
                                      Icons.filter_list_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: _viewAllArtists
                                ? const MyArtists()
                                : const ActivityFeed()),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return const Center(
                    child: Text(
                        "Oops, something went wrong, please check your connection"),
                  );
                })),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      endDrawer: Drawer(
        width: Get.width * 0.5,
        elevation: 0,
      ),
    );
  }
}
