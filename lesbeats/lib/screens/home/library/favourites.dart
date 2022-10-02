import 'package:flutter/material.dart';

class MyFavourites extends StatelessWidget {
  MyFavourites({super.key});

  final List<String> favouites = [
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
      child: ListView(
          children: favouites
              .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/rnb.jpg"))),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                e,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black45),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert,
                                color: Colors.black54)),
                      )
                    ],
                  ))
              .toList()),
    );
  }
}
