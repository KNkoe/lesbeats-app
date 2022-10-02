import 'package:flutter/material.dart';

class MyRecentlyPlayed extends StatelessWidget {
  MyRecentlyPlayed({super.key});

  final List<String> recentlyPlayed = [
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
      children: recentlyPlayed
          .map((e) => Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
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
                  const Text(
                    "Artist",
                    style: TextStyle(color: Colors.black45),
                  )
                ],
              ))
          .toList(),
    ));
  }
}
