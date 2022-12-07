import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/library/following.dart';
import 'package:lesbeats/screens/home/library/recentlyplayed.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/responsive.dart';

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
        return MyRecentlyPlayed();
      case 1:
        return MyFavourites();
      case 2:
        return MyFollowingPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Library",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: screenSize(context).height,
        width: screenSize(context).width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.2,
                fit: BoxFit.contain,
                image: AssetImage("assets/images/circle-scatter-haikei.png"))),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: DefaultTabController(
                length: 3,
                child: TabBar(
                    splashBorderRadius: BorderRadius.circular(20),
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                    indicator: DotIndicator(
                        color: Theme.of(context).primaryColor, radius: 8),
                    tabs: [
                      Tab(
                        child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    Theme.of(context).primaryColor,
                                disabledForegroundColor: Colors.white),
                            child: const Text("Recent")),
                      ),
                      Tab(
                        child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    Theme.of(context).primaryColor,
                                disabledForegroundColor: Colors.white),
                            child: const Text("Favourites")),
                      ),
                      Tab(
                        child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor:
                                    Theme.of(context).primaryColor,
                                disabledForegroundColor: Colors.white),
                            child: const Text("Following")),
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
