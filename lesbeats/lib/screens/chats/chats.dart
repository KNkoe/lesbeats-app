import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/screens/chats/message.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<MyChatScreen> createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  List<String> messages = [
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "Vicous",
    "Mjo Konondo",
    "Funky Debelicous",
    "Goodey",
    "Delicous",
    "VicIouS"
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: Get.height,
          width: Get.width,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Messages",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        Positioned(
            top: 150,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: Get.width,
              height: Get.height - 150,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Theme.of(context).backgroundColor),
              child: ListView(
                shrinkWrap: true,
                children: messages
                    .map((e) => InkWell(
                          onTap: (() {
                            Get.bottomSheet(const MyMessageScreen());
                          }),
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          minRadius: 30,
                                          backgroundImage: AssetImage(
                                              "assets/images/rnb.jpg"),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10, top: 20),
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              height: 40,
                                              child: const Text(
                                                "The actual message send to this user",
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              color: malachite,
                                              shape: BoxShape.circle),
                                          padding: const EdgeInsets.all(6),
                                          child: const Text(
                                            "1",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        const Text("15:09")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ))
      ],
    );
  }
}
