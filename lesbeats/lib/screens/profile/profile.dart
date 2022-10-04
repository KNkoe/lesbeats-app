import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/beats.dart';
import 'package:lesbeats/screens/profile/editprofile.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int selectedIndex = 0;

  Widget selectedTab(int index) {
    switch (index) {
      case 0:
        return const MyBeats();
      case 1:
        return const Text("Albums");
      default:
        return Container();
    }
  }

  final Stream<DocumentSnapshot> _usersStream =
      db.collection('users').doc(auth.currentUser!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
              itemBuilder: ((context) => [
                    PopupMenuItem(
                      child: ListTile(
                        minLeadingWidth: 2,
                        onTap: () {
                          Navigator.pop(context);
                          editprofile(context);
                        },
                        title: const Text("Edit profile"),
                        leading: const Icon(Icons.edit_attributes),
                      ),
                    ),
                    const PopupMenuItem(child: Divider()),
                    PopupMenuItem(
                        child: ListTile(
                      onTap: () async {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: AlertDialog(
                                    title: Column(
                                      children: const [
                                        Text("Log out"),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Are you sure you want to log out?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    actions: [
                                      OutlinedButton(
                                          style: cancelButtonStyle,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      ElevatedButton(
                                          style: confirmButtonStyle,
                                          onPressed: () async {
                                            await auth.signOut().then((value) =>
                                                Navigator.of(context)
                                                    .popAndPushNamed('/'));
                                          },
                                          child: const Text("Logout"))
                                    ],
                                  ),
                                ));
                      },
                      minLeadingWidth: 2,
                      title: const Text("Log out"),
                      leading: const Icon(Icons.logout_rounded),
                    ))
                  ]))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _usersStream,
          builder: (context, userSnapshot) {
            if (userSnapshot.hasError) {
              return Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 10),
                  Text('Something went wrong'),
                ],
              ));
            } else if (userSnapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            } else if (userSnapshot.hasData) {
              return Container(
                color: Theme.of(context).backgroundColor,
                child: Stack(
                  children: [
                    Animate(
                      effects: const [SlideEffect()],
                      child: Container(
                        height: 100,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Animate(
                      effects: const [FadeEffect()],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 8,
                                          color: Theme.of(context)
                                              .backgroundColor)),
                                  child: Animate(
                                    effects: const [ShimmerEffect()],
                                    child: const CircleAvatar(
                                      minRadius: 50,
                                      backgroundImage:
                                          AssetImage("assets/images/rnb.jpg"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            userSnapshot.data!["full name"]
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                        if (userSnapshot.data!["isVerified"])
                                          const Icon(
                                            Icons.verified,
                                            color: malachite,
                                          )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 10),
                                      child: Text(
                                          "@${userSnapshot.data!["username"]}"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Row(
                                              children: const [
                                                Text(
                                                  "3k",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(" Followers")
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Row(
                                              children: const [
                                                Text(
                                                  "1k",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(" Following")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DefaultTabController(
                              length: 2,
                              child: TabBar(
                                  onTap: (index) {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                  indicator: DotIndicator(
                                      color: Theme.of(context).primaryColor),
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4))),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text("Beats"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4))),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text("Lyrics"),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            selectedTab(selectedIndex)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
