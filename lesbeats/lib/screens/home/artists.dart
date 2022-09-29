import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyArtists extends StatefulWidget {
  const MyArtists({super.key});

  @override
  State<MyArtists> createState() => _MyArtistsState();
}

class _MyArtistsState extends State<MyArtists> {
  final List<String> artists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous",
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous"
  ];
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: artists
          .map((artist) => Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage("assets/images/artist.jpg"))),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(artist),
                                if (artists.indexOf(artist) == 0)
                                  const Icon(
                                    Icons.verified_sharp,
                                    size: 18,
                                    color: malachite,
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "2K",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54),
                                ),
                                Text(
                                  " Followers",
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.message,
                              color: Theme.of(context).primaryColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: (_isFollowing &&
                                        artists.indexOf(artist) == 0)
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                            onPressed: () {
                              setState(() {
                                _isFollowing = !_isFollowing;
                              });
                            },
                            child: Text(
                                (_isFollowing && artists.indexOf(artist) == 0)
                                    ? "Following"
                                    : "Follow")),
                      ],
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }
}
