import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lesbeats/screens/home/dashboard/explore.dart';
import 'package:lesbeats/screens/home/dashboard/genre.dart';
import 'package:lesbeats/screens/home/dashboard/lyrics.dart';
import 'package:lesbeats/widgets/theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int selectedTabIndex = 0;

  Widget selectedTab(int index) {
    switch (index) {
      case 0:
        return const TrendingPage();

      case 1:
        return const MyGenre();
      case 2:
        return const MyLyrcisScreen();
      default:
        return Container();
    }
  }

  final List<String> artists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

  final List<String> activities = [
    "Scandal",
    "Love affairs",
    "Soon",
    "How about that",
    "Vicious"
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          pinned: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {},
              icon: Iconify(
                Jam.menu,
                size: 32,
                color: Theme.of(context).backgroundColor,
              )),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                  angle: 0,
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
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Theme.of(context).backgroundColor,
                ))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(140),
            child: Column(
              children: [
                DefaultTabController(
                  length: 3,
                  child: TabBar(
                      onTap: (index) {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      indicatorColor: yellow,
                      tabs: const [
                        Tab(
                          child: Text("Explore"),
                        ),
                        Tab(
                          child: Text("Genres"),
                        ),
                        Tab(
                          child: Text("Lyrics"),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 400),
                    turns: _isCollapsed ? 45 / 180 : -45 / 180,
                    child: IconButton(
                        onPressed: () {
                          if (_isCollapsed) {
                            _scrollController.animateTo(200,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          } else {
                            _scrollController.animateTo(-200,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          }

                          setState(() {
                            _isCollapsed = !_isCollapsed;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black38,
                          size: 20,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        SliverFillRemaining(child: selectedTab(selectedTabIndex)),
      ],
    );
  }
}
