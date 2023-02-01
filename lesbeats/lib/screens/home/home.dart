import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:lesbeats/screens/home/dashboard.dart';
import 'package:lesbeats/screens/home/library.dart';
import 'package:lesbeats/screens/home/search.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

import '../../main.dart';
import '../../services/services.dart';

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

  final observer = LifecycleObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(observer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                icon: Icon(
                  selectedIndex == 0
                      ? FluentSystemIcons.ic_fluent_home_filled
                      : FluentSystemIcons.ic_fluent_home_regular,
                  color: selectedIndex == 0
                      ? Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor
                      : Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    selectedIndex == 1
                        ? FluentSystemIcons.ic_fluent_library_filled
                        : FluentSystemIcons.ic_fluent_library_regular,
                    color: selectedIndex == 1
                        ? Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedItemColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                  ),
                  label: "Library"),
              BottomNavigationBarItem(
                  icon: Iconify(
                    selectedIndex == 2 ? Bx.bxs_search : Bx.search,
                    color: selectedIndex == 2
                        ? Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedItemColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                  ),
                  label: "Search"),
              BottomNavigationBarItem(
                  icon: Iconify(
                    selectedIndex == 3 ? Ph.user_fill : Ph.user,
                    color: selectedIndex == 3
                        ? Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedItemColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                  ),
                  label: "Profile")
            ]));
  }
}
