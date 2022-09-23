import 'package:flutter/material.dart';

class MyBeats extends StatefulWidget {
  const MyBeats({super.key});

  @override
  State<MyBeats> createState() => _MyBeatsState();
}

class _MyBeatsState extends State<MyBeats> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(shrinkWrap: true, children: [
      Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 10),
            minVerticalPadding: 30,
            leading: Container(
              height: 70,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/artist.jpg"))),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  )),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Just in mind"),
                Row(
                  children: const [Text("R250")],
                )
              ],
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text("Artist | genre"),
            ),
            trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: ((context) => [
                      PopupMenuItem(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.edit),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Edit"),
                        ],
                      )),
                      PopupMenuItem(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Delete"),
                        ],
                      )),
                    ])),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Row(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.play_arrow,
                        size: 18,
                        color: Colors.grey,
                      ),
                      Text(
                        "34",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.download_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                      Text(
                        "34",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.favorite,
                        size: 18,
                        color: Colors.grey,
                      ),
                      Text(
                        "34",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
          const Divider()
        ],
      )
    ]));
  }
}
