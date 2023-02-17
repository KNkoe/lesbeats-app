import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lesbeats/widgets/format.dart';
import 'package:lesbeats/wrapper.dart';

import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../../main.dart';
import '../../../services/stream/audio_stream.dart';
import '../../../widgets/audio/follow.dart';
import '../../../widgets/audio/report.dart';
import '../../../widgets/decoration.dart';
import 'editprofile.dart';
import 'folders.dart';
import 'followers.dart';
import 'genres.dart';

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
        return MyGenres(
          uid: widget.uid,
        );
      case 2:
        return MyFolders(
          uid: widget.uid,
        );
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading:
            (widget.uid == auth.currentUser!.uid) ? false : true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryIconTheme.color,
        ),
        title: (widget.uid == auth.currentUser!.uid)
            ? Text(
                "Profile",
                style: Theme.of(context).textTheme.headline6!,
              )
            : const SizedBox(),
        actions: [
          if (widget.uid == auth.currentUser!.uid)
            PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topRight: const Radius.circular(0))),
                itemBuilder: ((context) => [
                      PopupMenuItem(
                        child: ListTile(
                          minLeadingWidth: 2,
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                builder: (context) => const EditProfile(),
                                barrierColor: Colors.transparent,
                                context: context);
                          },
                          title: const Text("Edit profile"),
                          leading: Icon(
                            Icons.edit_attributes,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
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
                                            ),
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
                                              try {
                                                auth.signOut().then((value) {
                                                  Navigator.popUntil(context,
                                                      (route) => false);

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              const Wrapper())));
                                                });

                                                final GoogleSignIn
                                                    googleSignIn =
                                                    GoogleSignIn();
                                                await googleSignIn.signOut();
                                                debugPrint("User Sign Out");
                                              } catch (e) {
                                                debugPrint(e.toString());
                                              }
                                            },
                                            child: const Text("Logout"))
                                      ],
                                    ),
                                  ));
                        },
                        minLeadingWidth: 2,
                        title: const Text("Log out"),
                        leading: Icon(
                          Icons.logout_rounded,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ))
                    ])),
          if (widget.uid != auth.currentUser!.uid)
            PopupMenuButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              report(widget.uid, "User");
                            });
                          },
                          child: const Text("Report account"))
                    ])
        ],
      ),
      body: StreamBuilder4<DocumentSnapshot, QuerySnapshot, QuerySnapshot,
              QuerySnapshot>(
          streams: StreamTuple4(
              _usersStream, _uploadsStream, _followersStream, _followingStream),
          builder: (context, snapshot) {
            if (snapshot.snapshot1.connectionState == ConnectionState.waiting ||
                snapshot.snapshot2.connectionState == ConnectionState.waiting ||
                snapshot.snapshot3.connectionState == ConnectionState.waiting ||
                snapshot.snapshot4.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  "assets/images/loading.gif",
                  height: 70,
                  width: 70,
                ),
              );
            } else if (snapshot.snapshot1.hasData &&
                snapshot.snapshot2.hasData &&
                snapshot.snapshot3.hasData &&
                snapshot.snapshot4.hasData) {
              try {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipOval(
                                      child: FadeInImage.assetNetwork(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              "assets/images/placeholder.jpg",
                                          image: snapshot
                                              .snapshot1.data!["photoUrl"]),
                                    ),
                                    // if (snapshot.snapshot1.data!['online'])
                                    //   online(context)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.snapshot1.data!["full name"]
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "@${snapshot.snapshot1.data!["username"]}"),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          if (snapshot
                                              .snapshot1.data!["isVerified"])
                                            const Icon(
                                              Icons.verified,
                                              color: Colors.green,
                                            )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(
                                            numberFormat(
                                                snapshot.snapshot2.data!.size),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          Text(" Uploads",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor))
                                        ],
                                      ),
                                    ),
                                    OpenContainer(
                                        closedColor: Colors.transparent,
                                        closedElevation: 0,
                                        closedBuilder: ((context, action) =>
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    numberFormat(snapshot
                                                        .snapshot3.data!.size),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Text(
                                                    " Followers",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )
                                                ],
                                              ),
                                            )),
                                        openBuilder: ((context, action) =>
                                            MyFollowers(
                                              snapshot: snapshot.snapshot3.data,
                                              follow: "Followers",
                                            ))),
                                    OpenContainer(
                                        closedColor: Colors.transparent,
                                        closedElevation: 0,
                                        closedBuilder: ((context, action) =>
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    numberFormat(snapshot
                                                        .snapshot4.data!.size),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Text(
                                                    " Following",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )
                                                ],
                                              ),
                                            )),
                                        openBuilder: ((context, action) =>
                                            MyFollowers(
                                              snapshot: snapshot.snapshot4.data,
                                              follow: "Following",
                                            ))),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (widget.uid != auth.currentUser!.uid)
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              foregroundColor: (following)
                                                  ? Colors.grey
                                                  : Theme.of(context)
                                                      .primaryColor),
                                          onPressed: () {
                                            if (following) {
                                              unfollow(auth.currentUser!.uid,
                                                  widget.uid);
                                              setState(() {
                                                following = false;
                                              });
                                            } else {
                                              follow(auth.currentUser!.uid,
                                                  widget.uid);
                                              setState(() {
                                                following = true;
                                              });
                                            }
                                          },
                                          child: Text(following
                                              ? "Unfollow"
                                              : "Follow")),
                                    const SizedBox(
                                      width: 10,
                                    ),

                                    // if (widget.uid != auth.currentUser!.uid)
                                    //   OpenContainer(
                                    //       closedElevation: 0,
                                    //       closedColor: Colors.transparent,
                                    //       closedBuilder: ((context, action) =>
                                    //           OutlinedButton.icon(
                                    //               onPressed: null,
                                    //               style: OutlinedButton.styleFrom(
                                    //                   disabledForegroundColor:
                                    //                       Theme.of(context)
                                    //                           .primaryColor),
                                    //               icon: const Icon(
                                    //                   Icons.message),
                                    //               label:
                                    //                   const Text("Message"))),
                                    //       openBuilder: ((context, action) =>
                                    //           MyChat(userId: widget.uid)))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultTabController(
                        length: 3,
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
                                      Text("Genres"),
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
                                      Text("Folders"),
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
                );
              } catch (e) {
                debugPrint(e.toString());
              }
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
