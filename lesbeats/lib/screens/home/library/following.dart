import 'package:flutter/material.dart';

class MyFollowingPage extends StatelessWidget {
  MyFollowingPage({super.key});

  final List<String> followedArtists = [
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous",
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      children: followedArtists
          .map((e) => Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/rnb.jpg"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      e,
                      style: const TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ))
          .toList(),
    ));
  }
}
