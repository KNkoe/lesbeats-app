import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/widgets/profile/beats.dart';
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
    return Container(
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).backgroundColor,
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
                style: Theme.of(context).textTheme.headline5,
              ),
              PopupMenuButton(
                  icon: const Icon(Icons.more_horiz),
                  itemBuilder: ((context) => [
                        const PopupMenuItem(
                          child: ListTile(
                            title: Text("Edit profile"),
                            leading: Icon(Icons.edit_attributes),
                          ),
                        ),
                        const PopupMenuItem(child: Divider()),
                        const PopupMenuItem(
                            child: ListTile(
                          title: Text("Log out"),
                          leading: Icon(Icons.logout_rounded),
                        ))
                      ]))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              CircleAvatar(
                minRadius: 50,
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
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Text(
                                "3k",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(" Followers")
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Text(
                                "1k",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                indicatorColor: coquilicot,
                tabs: [
                  Tab(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: coquilicot,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(10),
                      child: const Text("Beats"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: coquilicot,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(10),
                      child: const Text("Albums"),
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
    );
  }
}
