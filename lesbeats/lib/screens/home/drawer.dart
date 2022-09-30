import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:lesbeats/screens/chats/chats.dart';
import 'package:lesbeats/screens/home/genre.dart';
import 'package:lesbeats/screens/home/lyrics.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:lesbeats/screens/home/settings.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "@Vicious_kadd",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
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
                    const Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyChatScreen());
                        _scaffoldKey.currentState!.closeDrawer();
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
                        Get.to(() => const MySettings());
                        _scaffoldKey.currentState!.closeDrawer();
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
                    )
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
