import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/library/following.dart';
import 'package:lesbeats/widgets/decoration.dart';

import 'library/favourites.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  final List<String> followedArtists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

  int selectedIndex = 0;

  Widget selectedLibrary(int index) {
    switch (index) {
      case 0:
        return const MyFavourites();
      case 1:
        return MyFollowingPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Library",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                    indicator: DotIndicator(
                        color: Theme.of(context).primaryColor, radius: 8),
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Favorites"),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Following"),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            selectedLibrary(selectedIndex)
          ],
        ),
      ),
    );
  }
}
