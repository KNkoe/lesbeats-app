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
        child: ListView(
      shrinkWrap: true,
      children: [
        ListTile(
            leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10))),
            title: const Text("Just in mind"),
            subtitle: Column(
              children: [
                Row(
                  children: const [
                    Text("Vicious"),
                    SizedBox(
                      width: 10,
                    ),
                    Text("|  3:35 ")
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {}, child: const Icon(Icons.favorite)),
                    const Text("14"),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(Icons.play_arrow),
                    const Text("14"),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(Icons.download),
                    const Text("67")
                  ],
                )
              ],
            ),
            trailing: PopupMenuButton(
                icon: const Icon(Icons.more_horiz),
                itemBuilder: ((context) => [
                      const PopupMenuItem(
                        child: ListTile(
                          title: Text("Edit"),
                          leading: Icon(Icons.edit),
                        ),
                      ),
                      const PopupMenuItem(child: Divider()),
                      const PopupMenuItem(
                          child: ListTile(
                        title: Text("Delete"),
                        leading: Icon(Icons.delete),
                      ))
                    ])))
      ],
    ));
  }
}
