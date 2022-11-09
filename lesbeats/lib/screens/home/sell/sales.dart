import 'package:flutter/material.dart';
import 'package:lesbeats/screens/home/sell/upload.dart';
import 'package:lesbeats/widgets/responsive.dart';

class MySales extends StatefulWidget {
  const MySales({super.key});

  @override
  State<MySales> createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    backgroundColor: Theme.of(context).backgroundColor),
                onPressed: () {
                  showUpload(context);
                },
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.black54),
                )),
          )
        ],
      ),
      body: Container(
          color: Theme.of(context).primaryColor,
          height: screenSize(context).height,
          width: screenSize(context).width,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Theme.of(context).backgroundColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Uploads",
                        style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: Theme.of(context).primaryColor,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.sentiment_dissatisfied_rounded,
                        color: Colors.black12,
                        size: 34,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "No uploads",
                        style: TextStyle(color: Colors.black38),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
