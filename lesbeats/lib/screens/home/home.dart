import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/dashboard.dart';
import 'package:lesbeats/screens/home/library.dart';
import 'package:lesbeats/screens/home/search.dart';
import 'package:lesbeats/screens/home/upload_beat.dart';
import 'package:lesbeats/screens/profile/profile.dart';

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
        return const MySearchScreen();
      case 2:
        return const MyLibrary();
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
      body: destination(selectedIndex),
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
                  const PopupMenuItem(height: 2, child: Divider()),
                  PopupMenuItem(
                      child: ListTile(
                    leading: const Icon(Icons.paste),
                    title: const Text("Post Lyrics"),
                    onTap: () {},
                  ))
                ],
            icon: const Icon(Icons.play_arrow)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home_filled,
          Icons.search_sharp,
          Icons.library_music_outlined,
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
