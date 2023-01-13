import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/widgets/format.dart';
import 'package:lesbeats/widgets/load.dart';
import 'package:lesbeats/widgets/responsive.dart';

import '../../widgets/decoration.dart';
import 'chat.dart';

class MyChatList extends StatefulWidget {
  const MyChatList({super.key});

  @override
  State<MyChatList> createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
  late final Stream<QuerySnapshot> messages;

  @override
  void initState() {
    messages = db
        .collection("messages")
        .where("participants", arrayContains: auth.currentUser!.uid)
        .where("chatId", isEqualTo: "last message")
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Inbox",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline1!.color!),
          ),
          iconTheme:
              IconThemeData(color: Theme.of(context).primaryIconTheme.color),
          toolbarHeight: 50,
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(80),
          //   child: Column(
          //     children: [
          //       const Divider(),
          //       Container(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //         height: 70,
          //         child: TextField(
          //           decoration: InputDecoration(
          //               prefixIcon: const Padding(
          //                 padding: EdgeInsets.all(10),
          //                 child: Iconify(
          //                   Bx.search,
          //                   color: Colors.black38,
          //                 ),
          //               ),
          //               filled: true,
          //               floatingLabelBehavior: FloatingLabelBehavior.never,
          //               fillColor:
          //                   Theme.of(context).primaryColor.withOpacity(0.2),
          //               enabledBorder: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                   borderSide:
          //                       const BorderSide(color: Colors.transparent)),
          //               label: const Text(
          //                 "Search",
          //                 style: TextStyle(
          //                   color: Colors.black38,
          //                 ),
          //               )),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: messages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset(
                    "assets/images/loading.gif",
                    height: 70,
                    width: 70,
                  ),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final String userId =
                          snapshot.data!.docs[index].get("sender") ==
                                  auth.currentUser!.uid
                              ? snapshot.data!.docs[index].get("recipient")
                              : snapshot.data!.docs[index].get("sender");

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: OpenContainer(
                            closedColor: Colors.transparent,
                            closedElevation: 0,
                            closedBuilder: ((context, action) => Chat(
                                  userId: userId,
                                  snapshot: snapshot.data!.docs[index],
                                )),
                            openBuilder: ((context, action) =>
                                MyChat(userId: userId))),
                      );
                    });
              }

              return const SizedBox();
            }));
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.userId, required this.snapshot})
      : super(key: key);

  final String userId;
  final DocumentSnapshot snapshot;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final Stream<DocumentSnapshot> _userStream;
  late final String _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = auth.currentUser!.uid.hashCode >= widget.userId.hashCode
        ? '${auth.currentUser!.uid}+${widget.userId}'
        : '${widget.userId}+${auth.currentUser!.uid}';
    _userStream = db.collection("users").doc(widget.userId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ChatLoading();
          }

          if (snapshot.hasData) {
            final Timestamp timestamp = widget.snapshot['timestamp'];
            final messageSender = widget.snapshot['sender'];
            final formattedTimestamp =
                DateFormat.yMd().add_jm().format(timestamp.toDate());
            final status = widget.snapshot['status'] == 'seen';

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              leading: OpenContainer(
                closedColor: Colors.transparent,
                closedElevation: 0,
                closedBuilder: (context, action) => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipOval(
                      child: FadeInImage.assetNetwork(
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image: snapshot.data!.get("photoUrl")),
                    ),
                    if (snapshot.data!.get("online")) online(context)
                  ],
                ),
                openBuilder: (context, action) =>
                    MyProfilePage(snapshot.data!.get("uid")),
              ),
              title: Text(snapshot.data!.get("username"),
                  style: Theme.of(context).textTheme.subtitle2),
              subtitle: Row(
                children: [
                  if (messageSender == auth.currentUser!.uid)
                    status
                        ? Icon(
                            Icons.done_all,
                            color: Theme.of(context).primaryColor,
                          )
                        : Icon(
                            Icons.check,
                            color: Theme.of(context).primaryColor,
                          ),
                  if (messageSender == auth.currentUser!.uid)
                    const SizedBox(
                      width: 10,
                    ),
                  SizedBox(
                    width: screenSize(context).width * 0.45,
                    child: Text(decrypt(_chatId, widget.snapshot.get("text")),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.white54)),
                  ),
                ],
              ),
              trailing: SizedBox(
                height: 60,
                width: 50,
                child: Column(
                  children: [
                    Text(
                        '${formattedTimestamp.split(" ")[1]} ${formattedTimestamp.split(" ")[2]}'),
                    if (messageSender != auth.currentUser!.uid && !status)
                      Container(
                        height: 10,
                        width: 10,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor),
                      )
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        });
  }
}
