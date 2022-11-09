import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:lesbeats/screens/load.dart';
import 'package:lesbeats/widgets/responsive.dart';

import 'package:lesbeats/widgets/theme.dart';

import '../../widgets/animation.dart';
import 'activityfeed.dart';
import 'artists.dart';
import 'drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> topArtists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

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
                showModalBottomSheet(
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
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Theme.of(context).backgroundColor),
            child: !isLoading
                ? Column(
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
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    : Text(
                                        "View more",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color:
                                                Theme.of(context).primaryColor),
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
                                              begin: Offset(1, 0),
                                              end: Offset(0, 0))
                                        ],
                                        delay:
                                            delay(topArtists.indexOf(artist)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                      stops: const [
                                                        0.7,
                                                        0.3
                                                      ],
                                                      colors: [
                                                        Theme.of(context)
                                                            .canvasColor,
                                                        Theme.of(context)
                                                            .primaryColor
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
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    artist,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                                if (topArtists
                                                        .indexOf(artist) ==
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
                                    _scaffoldKey.currentState!.openEndDrawer();
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
                  )
                : const MyLoadingPage()),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      endDrawer: Drawer(
        width: Get.width * 0.5,
        elevation: 0,
      ),
    );
  }
}
