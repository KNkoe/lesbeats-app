import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/widgets/dashboard/dashboard.dart';

import 'widgets/drawer/list_tile.dart';

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
        return const Center(child: Text("person"));
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Les",
              style: TextStyle(),
            ),
            Text(
              "Beats",
              style: TextStyle(),
            ),
          ],
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: destination(selectedIndex)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.explore),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
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
