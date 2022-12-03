import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/chats/chats.dart';
import 'package:lesbeats/screens/home/genre.dart';
import 'package:lesbeats/screens/home/lyrics.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:lesbeats/screens/home/upload/uploads.dart';
import 'package:lesbeats/screens/home/settings.dart';
import 'package:lesbeats/widgets/theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDarkModeEnabled = false;

  final Stream<DocumentSnapshot> _userStream =
      db.collection("users").doc(auth.currentUser!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 0,
        child: Column(
          children: [
            Container(
              height: 220,
              padding: const EdgeInsets.only(left: 20),
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: _userStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 80,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        auth.currentUser!.photoURL!))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: Text(
                                      snapshot.data!["full name"],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "@${snapshot.data!["username"]}",
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        if (snapshot.data!["isVerified"])
                                          const Icon(
                                            Icons.verified,
                                            color: malachite,
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: SizedBox(
                                  height: 50,
                                  width: 70,
                                  child: DayNightSwitcher(
                                    dayBackgroundColor:
                                        Theme.of(context).backgroundColor,
                                    sunColor: Theme.of(context).indicatorColor,
                                    isDarkModeEnabled: isDarkModeEnabled,
                                    onStateChanged: (isDarkModeEnabled) {
                                      setState(() {
                                        this.isDarkModeEnabled =
                                            isDarkModeEnabled;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("An error occured"),
                      );
                    }
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
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
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: const Iconify(Bx.bxs_music),
                      title: const Text("Genres"),
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyLyricsScreen());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: const Iconify(Zondicons.music_artist),
                      title: const Text("Lyrics"),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyChatScreen());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      title: const Text("Messages"),
                      leading: Badge(
                          badgeColor: Theme.of(context).indicatorColor,
                          badgeContent: const Text(
                            "4",
                            style: TextStyle(color: Colors.white),
                          ),
                          child: const Iconify(Ri.chat_1_fill)),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MySales());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: const Icon(
                        Icons.upload,
                        color: Colors.black,
                      ),
                      title: const Text("Upload"),
                    ),
                    ListTile(
                      onTap: () {
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: const Icon(
                        Icons.attach_money,
                        color: Colors.black,
                      ),
                      title: const Text("Purchased"),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MySettings());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
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
                    ),
                    const AboutListTile(
                      icon: Icon(Icons.info),
                      applicationName: "Lesbeats",
                      applicationIcon: Image(
                          height: 30,
                          width: 30,
                          image: AssetImage("assets/images/Logo.png")),
                      applicationVersion: "1.0",
                      child: Text("About"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
