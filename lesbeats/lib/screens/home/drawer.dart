import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/ri.dart';

import '../../main.dart';
import '../chats/chat_list.dart';
import 'downloads.dart';
import 'genre/genre.dart';
import 'trending.dart';
import 'upload/uploads.dart';

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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  late final Uri emailLaunchUri;
  late final Uri helpAndFeedback;

  Future<void> _launchEmail() async {
    if (!await launchUrl(emailLaunchUri)) {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(helpAndFeedback)) {
      throw 'Could not launch $helpAndFeedback';
    }
  }

  @override
  void initState() {
    super.initState();
    emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'lesbeats0@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Lesbeats: Feedback or Suggestions',
      }),
    );

    helpAndFeedback =
        Uri.parse("http://lesbeats.nicepage.io/Lesbeats.html#sec-8ab1");
  }

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
                                            color: Colors.green,
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
                      onTap: () {
                        Get.to(() => const MyTrendingPage());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
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
                    const Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyChatList());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      title: const Text("Messages"),
                      leading: StreamBuilder<QuerySnapshot>(
                          stream: db
                              .collection("messages")
                              .where("recipient",
                                  isEqualTo: auth.currentUser!.uid)
                              .where("chatId", isEqualTo: "last message")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.size == 0) {
                                return const SizedBox();
                              }

                              return Badge(
                                  badgeColor: Theme.of(context).indicatorColor,
                                  badgeContent: Text(
                                    snapshot.data!.size.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: const Iconify(Ri.chat_1_fill));
                            }

                            return const SizedBox();
                          }),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyUploads());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: const Icon(
                        Icons.upload,
                        color: Colors.black,
                      ),
                      title: const Text("Upload"),
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     widget._scaffoldKey.currentState!.closeDrawer();
                    //   },
                    //   leading: const Icon(
                    //     Icons.attach_money,
                    //     color: Colors.black,
                    //   ),
                    //   title: const Text("Purchased"),
                    // ),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyDownloads());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: const Icon(
                        Icons.download,
                        color: Colors.black,
                      ),
                      title: const Text("Downloads"),
                    ),
                    const Divider(),
                    // ListTile(
                    //   onTap: () {
                    //     Get.to(() => const MySettings());
                    //     widget._scaffoldKey.currentState!.closeDrawer();
                    //   },
                    //   leading: const Icon(Icons.settings),
                    //   title: const Text("Settings"),
                    // ),
                    ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.share),
                      title: const Text("Tell a friend"),
                    ),
                    ListTile(
                      onTap: _launchUrl,
                      leading: const Icon(Icons.help),
                      title: const Text("Help and Feedback"),
                    ),
                    AboutListTile(
                      icon: const Icon(Icons.info),
                      applicationName: "Lesbeats",
                      applicationIcon: const Image(
                          height: 30,
                          width: 30,
                          image: AssetImage("assets/icon/_logo.png")),
                      applicationVersion: "1.0.0",
                      aboutBoxChildren: [
                        const Text("A goto place to buy and sell beats online"),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Features"),
                        const Divider(),
                        const Text("- A library of music tracks"),
                        const Text("- Personalization"),
                        const Text("- Social integration"),
                        const Text("- Producer profiles"),
                        const Text("- Playback control"),
                        const Text("- Offline playback"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Coming soon"),
                        const Divider(),
                        const Text("- In-app purchases"),
                        const Text("- Music recommendations"),
                        const Text("- Background playback"),
                        const Text("- Audio quality options"),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                            "Lesbeats is developed by Katleho Nkoe, a solo developer based in Maseru Lesotho. With a passion for music and technology, Katleho created Lesbeats to provide a simple and intuitive way for producers to sell their beats. If you have any feedback or suggestions, Jane would love to hear from you! You can contact her at "),
                        GestureDetector(
                          onTap: _launchEmail,
                          child: const Text(
                            "Katleholnkoe@gmail.com",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                      child: const Text("About"),
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
