import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/theme.dart';

import 'activityfeed.dart';
import 'artists.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  final List<String> topArtists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];

  bool _viewAllArtists = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Artists",
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _viewAllArtists = !_viewAllArtists;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _viewAllArtists
                          ? Text(
                              "View less",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).primaryColor),
                            )
                          : Text(
                              "View more",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).primaryColor),
                            ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: topArtists
                    .map((artist) => Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  height: 90,
                                  width: 90,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/artist.jpg'))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(artist),
                                    ),
                                    if (topArtists.indexOf(artist) == 0)
                                      const Icon(
                                        Icons.verified,
                                        color: malachite,
                                        size: 18,
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _viewAllArtists ? "Artists" : "Activity Feed",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                      onTap: () {},
                      child: const Icon(Icons.arrow_drop_up_outlined))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child:
                    _viewAllArtists ? const MyArtists() : const ActivityFeed()),
          ],
        ),
      ),
    );
  }
}
