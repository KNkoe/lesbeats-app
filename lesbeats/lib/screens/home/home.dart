import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:lesbeats/screens/home/dashboard.dart';
import 'package:lesbeats/screens/home/library.dart';
import 'package:lesbeats/screens/home/search.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/fluent.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  int selectedDrawerItem = 0;

  Widget destination(index) {
    switch (index) {
      case 0:
        return const Dashboard();
      case 1:
        return const MyLibrary();

      case 2:
        return const MySearchScreen();

      case 3:
        return MyProfilePage(auth.currentUser!.uid);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: destination(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) => setState(() {
                  selectedIndex = value;
                }),
            currentIndex: selectedIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Iconify(
                  selectedIndex == 0
                      ? Fluent.home_32_filled
                      : Fluent.home_32_regular,
                  color: selectedIndex == 0
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor
                      : Colors.black38,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Iconify(
                    selectedIndex == 1
                        ? Fluent.library_20_filled
                        : Fluent.library_20_regular,
                    color: selectedIndex == 1
                        ? Theme.of(context).primaryIconTheme.color
                        : Colors.black38,
                  ),
                  label: "Library"),
              BottomNavigationBarItem(
                  icon: Iconify(
                    selectedIndex == 2 ? Bx.bxs_search : Bx.search,
                    color: selectedIndex == 2
                        ? const Color(0xff264653)
                        : Colors.black38,
                  ),
                  label: "Search"),
              BottomNavigationBarItem(
                  icon: Iconify(
                    selectedIndex == 3 ? Ph.user_fill : Ph.user,
                    color: selectedIndex == 3
                        ? const Color(0xff264653)
                        : Colors.black38,
                  ),
                  label: "Profile")
            ]));
  }
}
