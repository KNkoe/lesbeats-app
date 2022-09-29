import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:lesbeats/screens/home/genre.dart';
import 'package:lesbeats/screens/home/lyrics.dart';
import 'package:lesbeats/screens/home/search.dart';
import 'package:lesbeats/widgets/theme.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/bxs.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

import '../../widgets/animation.dart';
import 'activityfeed.dart';
import 'artists.dart';

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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Les",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.jura().fontFamily,
                  color: Theme.of(context).backgroundColor),
            ),
            Text(
              "beats",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: GoogleFonts.jura().fontFamily,
                  color: Theme.of(context).backgroundColor),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showBottomSheet(
                    context: context,
                    builder: (context) => const MySearchScreen());
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
          padding: const EdgeInsets.all(20),
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
      drawer: SafeArea(
        child: Drawer(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 80,
                        width: 100,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/rnb.jpg"))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Katleho Nkoe",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "@Vicious_kadd",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Iconify(Ion.rocket),
                        title: const Text("Trending"),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => const MyGenre());
                          _scaffoldKey.currentState!.closeDrawer();
                        },
                        leading: const Iconify(Bx.bxs_music),
                        title: const Text("Genres"),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => const MyLyricsScreen());
                          _scaffoldKey.currentState!.closeDrawer();
                        },
                        leading: const Iconify(Zondicons.music_artist),
                        title: const Text("Lyrics"),
                      ),
                      const ListTile(
                        title: Text(
                          "My Collection",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Iconify(Ic.outline_favorite),
                        title: const Text("Favourites"),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: const Iconify(Bxs.like),
                        title: const Text("Following"),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.share),
                  title: const Text("Tell a friend"),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.help),
                  title: const Text("Help and Feadback"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
