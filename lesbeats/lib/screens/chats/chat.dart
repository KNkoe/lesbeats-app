import 'package:animations/animations.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/format.dart';

class MyChat extends StatefulWidget {
  const MyChat({super.key, required this.userId});
  final String userId;

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final TextEditingController _textController = TextEditingController();
  late final Stream<QuerySnapshot> _chatStream;
  late String _chatId;

  final double pi = 3.1415926535897932;

  @override
  void initState() {
    super.initState();
    _chatId = auth.currentUser!.uid.hashCode >= widget.userId.hashCode
        ? '${auth.currentUser!.uid}+${widget.userId}'
        : '${widget.userId}+${auth.currentUser!.uid}';

    debugPrint("CHATID: $_chatId");

    _chatStream = db
        .collection('messages')
        .where('chatId', isEqualTo: _chatId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: db.collection("users").doc(widget.userId).snapshots(),
        builder: (context, usersnapshot) {
          if (usersnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Image.asset(
                  "assets/images/loading.gif",
                  height: 70,
                  width: 70,
                ),
              ),
            );
          }

          if (usersnapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: OpenContainer(
                  closedColor: Colors.transparent,
                  closedElevation: 0,
                  closedBuilder: (context, action) => Row(
                    children: [
                      ClipOval(
                        child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/placeholder.jpg",
                            height: 40,
                            fit: BoxFit.cover,
                            width: 40,
                            image: usersnapshot.data!.get("photoUrl")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(usersnapshot.data!.get("username"),
                          style: Theme.of(context).textTheme.subtitle1),
                      if (usersnapshot.data!.get("online")) online(context)
                    ],
                  ),
                  openBuilder: (context, action) =>
                      MyProfilePage(usersnapshot.data!.get("uid")),
                ),
                iconTheme: IconThemeData(
                  color: Theme.of(context).textTheme.headline6!.color,
                ),
                actions: [
                  Transform.rotate(
                    angle: (pi / 180) * 270,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new)),
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Divider(),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _chatStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Image.asset(
                                  "assets/images/loading.gif",
                                  height: 70,
                                  width: 70,
                                ),
                              );
                            }

                            if (snapshot.hasData) {
                              final messages = snapshot.data!.docs.reversed;
                              List<Widget> messageWidgets = [];

                              for (var message in messages) {
                                final messageText =
                                    decrypt(_chatId, message['text']);
                                final messageSender = message['sender'];
                                final messageRecipient = message['recipient'];
                                final Timestamp timestamp =
                                    message['timestamp'];
                                final status = message['status'] == 'seen';

                                debugPrint(
                                    "STATUS : $status $messageRecipient");

                                if (!status &&
                                    messageRecipient == auth.currentUser!.uid) {
                                  message.reference.set({"status": 'seen'},
                                      SetOptions(merge: true));
                                  db.collection("messages").doc(_chatId).set({
                                    'status': 'seen',
                                  }, SetOptions(merge: true));
                                }

                                final formattedTimestamp = DateFormat.yMd()
                                    .add_jm()
                                    .format(timestamp.toDate());

                                final messageWidget = Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          messageSender == auth.currentUser!.uid
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        BubbleSpecialThree(
                                          isSender: messageSender ==
                                              auth.currentUser!.uid,
                                          text: messageText,
                                          color: messageSender ==
                                                  auth.currentUser!.uid
                                              ? Theme.of(context).primaryColor
                                              : const Color(0xFFE8E8EE),
                                          tail: true,
                                          seen: status &&
                                              messageSender ==
                                                  auth.currentUser!.uid,
                                          sent: !status &&
                                              messageSender ==
                                                  auth.currentUser!.uid,
                                          textStyle: TextStyle(
                                              color: messageSender ==
                                                      auth.currentUser!.uid
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              '${formattedTimestamp.split(" ")[1]} ${formattedTimestamp.split(" ")[2]}'),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                                messageWidgets.add(messageWidget);
                              }
                              return ListView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                children: messageWidgets,
                              );
                            }

                            return const SizedBox();
                          }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(color: Colors.black12),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                    hintText: 'Enter message...',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .color),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              onPressed: () {
                                if (_textController.text.isNotEmpty) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  db.collection("messages").add({
                                    'text':
                                        encrypt(_chatId, _textController.text),
                                    'sender': auth.currentUser!.uid,
                                    'recipient': widget.userId,
                                    'chatId': _chatId,
                                    'type': 'text',
                                    'status': 'sent',
                                    'timestamp': DateTime.now(),
                                    'participants': [
                                      auth.currentUser!.uid,
                                      widget.userId
                                    ]
                                  });
                                  db.collection("messages").doc(_chatId).set({
                                    'text':
                                        encrypt(_chatId, _textController.text),
                                    'sender': auth.currentUser!.uid,
                                    'recipient': widget.userId,
                                    'type': 'text',
                                    'chatId': 'last message',
                                    'status': 'sent',
                                    'timestamp': DateTime.now(),
                                    'participants': [
                                      auth.currentUser!.uid,
                                      widget.userId
                                    ]
                                  });
                                }

                                _textController.clear();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        });
  }
}
