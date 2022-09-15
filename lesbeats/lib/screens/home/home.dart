import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/explore/explore.dart';
import 'package:lesbeats/screens/home/widgets/upload_beat.dart';
import 'package:lesbeats/screens/profile/profile.dart';

import 'drawer/list_tile.dart';

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
        return const MyDashBoard();
      case 1:
        return const Center(child: Text("Chat"));
      case 2:
        return const Center(child: Text("Favourites"));
      case 3:
        return const MyProfilePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AnimatedSwitcher(
          transitionBuilder: (child, animation) {
            const begin = Offset(0.02, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          duration: const Duration(seconds: 1),
          child: destination(selectedIndex)),
      drawer: Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Johnny")),
            drawerListTile(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            drawerListTile(
              context,
              icon: Icons.info,
              title: 'About',
              onTap: () {},
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: PopupMenuButton(
            itemBuilder: (contex) => [
                  PopupMenuItem(
                      child: ListTile(
                    leading: const Icon(Icons.upload),
                    title: const Text("Upload beat"),
                    onTap: () {
                      Navigator.pop(context);
                      showUpload(context);
                    },
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    leading: const Icon(Icons.paste),
                    title: const Text("Post Lyrics"),
                    onTap: () {},
                  ))
                ],
            icon: const Icon(Icons.add)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.explore,
          Icons.chat_bubble,
          Icons.favorite_rounded,
          Icons.person
        ],
        inactiveColor: Colors.grey,
        activeColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        activeIndex: selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 30,
        rightCornerRadius: 30,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
      ),
    );
  }
}
