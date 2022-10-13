import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lesbeats/models/genre.dart';
import 'package:lesbeats/widgets/animation.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyGenre extends StatefulWidget {
  const MyGenre({super.key});

  @override
  State<MyGenre> createState() => _MyGenreState();
}

class _MyGenreState extends State<MyGenre> {
  List<Genre> genres = [
    Genre(genre: "RNB", coverUrl: "assets/images/rnb.jpg"),
    Genre(genre: "Amapiano", coverUrl: "assets/images/artist.jpg"),
    Genre(genre: "Trap", coverUrl: "assets/images/rnb.jpg"),
    Genre(genre: "Rock", coverUrl: "assets/images/rock.jpg"),
    Genre(genre: "House", coverUrl: "assets/images/house.jpg"),
    Genre(genre: "HipHop", coverUrl: "assets/images/hiphop.jpg"),
    Genre(genre: "Afrobeat", coverUrl: "assets/images/genre.jpeg"),
    Genre(genre: "Other", coverUrl: "assets/images/genre.jpeg")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Genres"),
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
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).backgroundColor),
          child: GridView.count(
            crossAxisCount: 2,
            children: genres
                .map(
                  (genre) => InkWell(
                    onTap: () {},
                    child: Animate(
                      effects: const [FadeEffect(), ShimmerEffect()],
                      delay: genreDelay(genres.indexOf(genre)),
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
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(genre.coverUrl)),
                            color: starCommandblue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          genre.genre,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
