import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    icon: const Iconify(Ri.search_2_line),
                    hintText: "Artists, beats, genre or lyrics",
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(30))),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.schedule,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Recent searches",
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "See all",
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: const [Text("data")],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
