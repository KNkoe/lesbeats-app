import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Stack(
          children: [
            Container(
              height: 180,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white),
                      ),
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
                                      editprofile(context);
                                    },
                                    title: const Text("Edit profile"),
                                    leading: const Icon(Icons.edit_attributes),
                                  ),
                                ),
                                const PopupMenuItem(child: Divider()),
                                PopupMenuItem(
                                    child: ListTile(
                                  onTap: () {
                                    Future.delayed(const Duration(seconds: 2))
                                        .then((value) => Navigator.of(context)
                                            .popAndPushNamed('/login'));
                                  },
                                  minLeadingWidth: 2,
                                  title: const Text("Log out"),
                                  leading: const Icon(Icons.logout_rounded),
                                ))
                              ]))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 8,
                                color: Theme.of(context).backgroundColor)),
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
                                  "Katleho Nkoe",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              const Icon(
                                Icons.verified,
                                color: malachite,
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text("@vicious_kadd"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: const [
                                      Text(
                                        "3k",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(" Followers")
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: const [
                                      Text(
                                        "1k",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                        indicatorColor: Theme.of(context).primaryColor,
                        indicator:
                            DotIndicator(color: Theme.of(context).primaryColor),
                        tabs: [
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Beats"),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
