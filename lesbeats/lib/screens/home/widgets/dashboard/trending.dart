import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/responsive.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  List<String> artists = ["Mjo", "Funky", "Goodey", "Delicous", "Vicous"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Artists",
          ),
          SizedBox(
            height: screenSize(context).height * 0.1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [],
            ),
          ),
        ],
      ),
    );
  }
}
