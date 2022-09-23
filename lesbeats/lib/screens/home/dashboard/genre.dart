import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyGenre extends StatefulWidget {
  const MyGenre({super.key});

  @override
  State<MyGenre> createState() => _MyGenreState();
}

class _MyGenreState extends State<MyGenre> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    spreadRadius: -2,
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                  )
                ],
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/rnb.jpg")),
                color: starCommandblue,
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "RnB",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                spreadRadius: -2,
                blurRadius: 12,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              )
            ], color: coquilicot, borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Amapiano",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    spreadRadius: -2,
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                  )
                ],
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/artist.jpg")),
                color: starCommandblue,
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Trap",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    spreadRadius: -2,
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                  )
                ],
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/rock.jpg")),
                color: starCommandblue,
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Rock",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    spreadRadius: -2,
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                  )
                ],
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/house.jpg")),
                color: starCommandblue,
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "House",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    spreadRadius: -2,
                    blurRadius: 12,
                    color: Color.fromRGBO(0, 0, 0, 0.9),
                  )
                ],
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/hiphop.jpg")),
                color: starCommandblue,
                borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Hiphop",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                spreadRadius: -2,
                blurRadius: 12,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              )
            ], color: coquilicot, borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Afro",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                spreadRadius: -2,
                blurRadius: 12,
                color: Color.fromRGBO(0, 0, 0, 0.2),
              )
            ], color: coquilicot, borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Other",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
