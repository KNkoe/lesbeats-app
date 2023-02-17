import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/bx.dart';

import '../../../main.dart';
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
  late final Uri termsAndConditions;

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

  Future<void> _launchTerms() async {
    if (!await launchUrl(termsAndConditions)) {
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
    termsAndConditions =
        Uri.parse("http://lesbeats.nicepage.io/Terms-and-conditions.html");
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
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                placeholder: "assets/images/placeholder.jpg",
                                image: auth.currentUser!.photoURL!),
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
                                            color: Colors.white,
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
                                    child: EasyDynamicThemeBtn()),
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
                      leading: Iconify(
                        Ion.rocket,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                      title: const Text("Trending"),
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyGenre());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: Iconify(
                        Bx.bxs_music,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                      title: const Text("Genres"),
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     Get.to(() => const MyChatList());
                    //     widget._scaffoldKey.currentState!.closeDrawer();
                    //   },
                    //   title: const Text("Messages"),
                    //   leading: StreamBuilder<QuerySnapshot>(
                    //       stream: db
                    //           .collection("messages")
                    //           .where("recipient",
                    //               isEqualTo: auth.currentUser!.uid)
                    //           .where("chatId", isEqualTo: "last message")
                    //           .snapshots(),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.hasData) {
                    //           return Badge(
                    //               isLabelVisible: snapshot.data!.size != 0,
                    //               backgroundColor:
                    //                   Theme.of(context).indicatorColor,
                    //               label: Text(
                    //                 snapshot.data!.size.toString(),
                    //                 style: const TextStyle(color: Colors.white),
                    //               ),
                    //               child: Iconify(
                    //                 Ri.chat_1_fill,
                    //                 color: Theme.of(context)
                    //                     .textTheme
                    //                     .headline1!
                    //                     .color,
                    //               ));
                    //         }

                    //         return Iconify(
                    //           Ri.chat_1_fill,
                    //           color:
                    //               Theme.of(context).textTheme.headline1!.color,
                    //         );
                    //       }),
                    // ),
                    ListTile(
                      onTap: () {
                        Get.to(() => const MyUploads());
                        widget._scaffoldKey.currentState!.closeDrawer();
                      },
                      leading: Icon(
                        Icons.upload,
                        color: Theme.of(context).textTheme.headline1!.color,
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
                      leading: Icon(
                        Icons.download,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                      title: const Text("Downloads"),
                    ),
                    const Divider(),
                    // ListTile(
                    //   onTap: () {
                    //     Get.to(() => const MyWallet());
                    //     widget._scaffoldKey.currentState!.closeDrawer();
                    //   },
                    //   leading: Icon(
                    //     FluentSystemIcons.ic_fluent_payment_filled,
                    //     color: Theme.of(context).textTheme.headline1!.color,
                    //   ),
                    //   title: const Text("Wallet"),
                    // ),
                    // const Divider(),

                    // ListTile(
                    //   onTap: () {
                    //     Get.to(() => const MySettings());
                    //     widget._scaffoldKey.currentState!.closeDrawer();
                    //   },
                    //   leading: const Icon(Icons.settings),
                    //   title: const Text("Settings"),
                    // ),
                    ListTile(
                      onTap: _launchTerms,
                      leading: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).textTheme.subtitle1!.color,
                      ),
                      title: const Text("Terms and Conditions"),
                    ),
                    ListTile(
                      onTap: _launchUrl,
                      leading: Icon(
                        Icons.help,
                        color: Theme.of(context).textTheme.subtitle1!.color,
                      ),
                      title: const Text("Help and Feedback"),
                    ),
                    ListTileTheme(
                      child: AboutListTile(
                        icon: Icon(
                          Icons.info,
                          color: Theme.of(context).textTheme.subtitle1!.color,
                        ),
                        applicationName: "Lesbeats",
                        applicationIcon: const Image(
                            height: 30,
                            width: 30,
                            image: AssetImage("assets/icon/_logo.png")),
                        applicationVersion: "1.0.0",
                        aboutBoxChildren: [
                          const Text(
                              "A goto place to buy and sell beats online"),
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
                              "Lesbeats is developed by Katleho Nkoe, a solo developer based in Maseru Lesotho. With a passion for music and technology, Katleho created Lesbeats to provide a simple and intuitive way for producers to sell their beats. If you have any feedback or suggestions, Katleho would love to hear from you! You can contact him at "),
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
                        child: Text(
                          "About",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
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
