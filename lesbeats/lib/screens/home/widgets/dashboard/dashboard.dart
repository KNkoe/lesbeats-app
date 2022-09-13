import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/widgets/dashboard/trending.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int selectedIndex = 0;

  Widget selectedTab(int index) {
    switch (index) {
      case 0:
        return const TrendingPage();
      case 1:
        return const Text("Artists");
      case 2:
        return const Text("Genre");
      case 3:
        return const Text("Free");
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          SizedBox(
            height: screenSize(context).height * 0.1,
            child: TextField(
              decoration: InputDecoration(
                  label: const Text("Search"),
                  fillColor: Theme.of(context).backgroundColor,
                  filled: true,
                  suffixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
          ),
          DefaultTabController(
            length: 4,
            child: TabBar(
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                indicatorColor: yellow,
                tabs: const [
                  Tab(
                    child: Text("Trending"),
                  ),
                  Tab(child: Text("Artists")),
                  Tab(
                    child: Text("Genre"),
                  ),
                  Tab(
                    child: Text("Free"),
                  )
                ]),
          ),
          selectedTab(selectedIndex)
        ],
      ),
    );
  }
}
