import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/responsive.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Top Artists",
                style: TextStyle(color: Colors.white60),
              ),
              SizedBox(
                height: screenSize(context).height * 0.1,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
