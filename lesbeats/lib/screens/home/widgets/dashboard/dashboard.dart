import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lesbeats/screens/home/widgets/dashboard/trending.dart';
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.menu,
                      color: Theme.of(context).backgroundColor,
                    ),
                    Row(
                      children: [
                        Transform.rotate(
                            angle: 25,
                            child: const Icon(
                              Icons.music_note,
                              color: yellow,
                            )),
                        Text(
                          "Les",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: GoogleFonts.jura().fontFamily,
                              color: Theme.of(context).backgroundColor),
                        ),
                        Text(
                          "beats",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              fontFamily: GoogleFonts.jura().fontFamily,
                              color: Theme.of(context).backgroundColor),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.notifications,
                      color: Theme.of(context).backgroundColor,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 70,
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
            ],
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 230,
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      selectedTab(selectedIndex),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
