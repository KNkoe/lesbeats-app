import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/widgets/theme.dart';

class MyArtists extends StatefulWidget {
  const MyArtists({super.key});

  @override
  State<MyArtists> createState() => _MyArtistsState();
}

class _MyArtistsState extends State<MyArtists> {
  bool _isFollowing = false;

  late final Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    _usersStream = db.collection('users').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  if (snapshot.data!.docs[index]["uid"] !=
                      auth.currentUser!.uid) {
                    if (index > 4) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OpenContainer(
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            closedBuilder: ((context, action) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage(
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                                placeholder: const AssetImage(
                                                    "assets/images/loading.gif"),
                                                image: NetworkImage(snapshot
                                                    .data!
                                                    .docs[index]["photoUrl"])),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(snapshot.data!
                                                      .docs[index]["username"]),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  if (snapshot.data!.docs[index]
                                                      ["isVerified"])
                                                    const Icon(
                                                      Icons.verified_sharp,
                                                      size: 18,
                                                      color: Colors.white,
                                                    )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: const [
                                                  Text(
                                                    "2K",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    " Followers",
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.message,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      (_isFollowing &&
                                                              index == 0)
                                                          ? Colors.grey
                                                          : Theme.of(context)
                                                              .primaryColor),
                                              onPressed: () {
                                                setState(() {
                                                  _isFollowing = !_isFollowing;
                                                });
                                              },
                                              child: Text(
                                                  (_isFollowing && index == 0)
                                                      ? "Following"
                                                      : "Follow")),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            openBuilder: ((context, action) => MyProfilePage(
                                snapshot.data!.docs[index]["uid"]))),
                      );
                    }
                  }
                  return const SizedBox();
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2,
            ));
          }
          return Container();
        });
  }
}
