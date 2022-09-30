import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';

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
        height: Get.height,
        width: Get.width,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).backgroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Top Artists",
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
                                                  'assets/images/artist.jpg'))),
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
                      style: const TextStyle(color: Colors.grey),
                    ),
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
          ),
        ),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
    );
  }
}
