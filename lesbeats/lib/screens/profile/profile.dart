import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/editprofile.dart';
import 'package:lesbeats/services/stream/follow.dart';
import 'package:lesbeats/services/stream/audio_stream.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage(this.uid, {super.key});
  final String uid;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int selectedIndex = 0;

  Widget selectedTab(int index) {
    switch (index) {
      case 0:
        return Expanded(
            child: MyAudioStream(stream: _audioStream, isProfileOpened: true));
      case 1:
        return const Text("Albums");
      default:
        return Container();
    }
  }

  late final Stream<DocumentSnapshot> _usersStream;
  late final Stream<QuerySnapshot> _audioStream;
  late final Stream<QuerySnapshot> _uploadsStream;
  late final Stream<QuerySnapshot> _followersStream;
  late final Stream<QuerySnapshot> _followingStream;

  bool following = false;

  @override
  void initState() {
    super.initState();
    _usersStream = db.collection('users').doc(widget.uid).snapshots();
    _audioStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: widget.uid)
        .orderBy("uploadedAt", descending: true)
        .snapshots();
    _uploadsStream = db
        .collection("tracks")
        .where("artistId", isEqualTo: widget.uid)
        .orderBy("uploadedAt", descending: true)
        .snapshots();

    _followersStream = db
        .collection("users")
        .doc(widget.uid)
        .collection("followers")
        .snapshots();

    _followingStream = db
        .collection("users")
        .doc(widget.uid)
        .collection("following")
        .snapshots();

    db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .doc(widget.uid)
        .get()
        .then((doc) {
      following = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: (widget.uid == auth.currentUser!.uid)
            ? Text(
                "Profile",
                style: Theme.of(context).textTheme.headline6!,
              )
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).textTheme.headline6!.color,
                )),
        actions: [
          if (widget.uid == auth.currentUser!.uid)
            PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
                itemBuilder: ((context) => [
                      PopupMenuItem(
                        child: ListTile(
                          minLeadingWidth: 2,
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                    context: context,
                                    builder: ((context) => const EditProfile()))
                                .then((_) => setState(() {}));
                          },
                          title: const Text("Edit profile"),
                          leading: const Icon(Icons.edit_attributes),
                        ),
                      ),
                      const PopupMenuItem(child: Divider()),
                      PopupMenuItem(
                          child: ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) => BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: AlertDialog(
                                      title: Column(
                                        children: const [
                                          Text("Log out"),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Are you sure you want to log out?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black54),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceAround,
                                      actions: [
                                        OutlinedButton(
                                            style: cancelButtonStyle,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel")),
                                        ElevatedButton(
                                            style: confirmButtonStyle,
                                            onPressed: () async {
                                              await auth.signOut().then(
                                                  (value) => Navigator.of(
                                                          context)
                                                      .popAndPushNamed('/'));
                                            },
                                            child: const Text("Logout"))
                                      ],
                                    ),
                                  ));
                        },
                        minLeadingWidth: 2,
                        title: const Text("Log out"),
                        leading: const Icon(Icons.logout_rounded),
                      ))
                    ])),
          if (widget.uid != auth.currentUser!.uid)
            PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
                itemBuilder: (context) =>
                    [const PopupMenuItem(child: Text("Report account"))])
        ],
      ),
      body: StreamBuilder4<DocumentSnapshot, QuerySnapshot, QuerySnapshot,
              QuerySnapshot>(
          streams: StreamTuple4(
              _usersStream, _uploadsStream, _followersStream, _followingStream),
          builder: (context, snapshot) {
            if (snapshot.snapshot1.connectionState == ConnectionState.waiting &&
                snapshot.snapshot2.connectionState == ConnectionState.waiting &&
                snapshot.snapshot3.connectionState == ConnectionState.waiting &&
                snapshot.snapshot4.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else if (snapshot.snapshot1.hasData &&
                snapshot.snapshot2.hasData &&
                snapshot.snapshot3.hasData &&
                snapshot.snapshot4.hasData) {
              return Animate(
                effects: const [FadeEffect()],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 8,
                                    color: Theme.of(context).backgroundColor)),
                            child: Animate(
                              effects: const [ShimmerEffect()],
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                minRadius: 50,
                                backgroundImage: NetworkImage(
                                    snapshot.snapshot1.data!["photoUrl"]),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.snapshot2.data!.size.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Text(" Uploads",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.snapshot3.data!.size.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Text(" Followers",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.snapshot4.data!.size
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      Text(
                                        " Following",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.snapshot1.data!["full name"]
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  if (snapshot.snapshot1.data!["isVerified"])
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                    )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                    "@${snapshot.snapshot1.data!["username"]}"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          if (widget.uid != auth.currentUser!.uid)
                            OutlinedButton(
                                onPressed: () {
                                  if (following) {
                                    unfollow(auth.currentUser!.uid, widget.uid);
                                    setState(() {
                                      following = false;
                                    });
                                  } else {
                                    follow(auth.currentUser!.uid, widget.uid);
                                    setState(() {
                                      following = true;
                                    });
                                  }
                                },
                                child: Text(following ? "Unfollow" : "Follow")),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTabController(
                        length: 2,
                        child: TabBar(
                            onTap: (index) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            indicatorColor: Theme.of(context).primaryColor,
                            indicator: DotIndicator(
                                color: Theme.of(context).primaryColor),
                            tabs: [
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4))),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Beats"),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4))),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Lyrics"),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedTab(selectedIndex)
                    ],
                  ),
                ),
              );
            }

            if (snapshot.snapshot1.hasError || snapshot.snapshot2.hasError) {
              return Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 10),
                  Text('An error occured!'),
                ],
              ));
            }

            return const SizedBox();
          }),
    );
  }
}
