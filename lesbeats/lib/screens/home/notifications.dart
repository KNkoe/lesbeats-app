import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyNotifications extends StatefulWidget {
  const MyNotifications({super.key});

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  late Stream<QuerySnapshot> _notificationsStream;
  int unread = 0;

  @override
  void initState() {
    super.initState();
    _notificationsStream = db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("notifications")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notificationsStream,
      builder: ((context, snapshot) {
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
          return Padding(
              padding: const EdgeInsets.all(10),
              child: PopupMenuButton(
                child: Badge(
                    padding: const EdgeInsets.all(7),
                    elevation: 0,
                    badgeColor: unread == 0
                        ? Colors.transparent
                        : Theme.of(context).indicatorColor,
                    badgeContent: unread == 0
                        ? const SizedBox()
                        : Text(
                            unread.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                    child: const Icon(Icons.notifications)),
                itemBuilder: (context) =>
                    snapshot.data!.docs.map((notification) {
                  Timestamp timestamp = notification["timestamp"];

                  final timeDifference =
                      DateTime.now().difference(timestamp.toDate());

                  final timeAgo = DateTime.now().subtract(timeDifference);

                  return PopupMenuItem(
                      child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            if (!notification["read"]) {
                              Future.delayed(
                                  Duration.zero,
                                  () => notification.reference.set(
                                      {"read": true}, SetOptions(merge: true)));
                            }
                          });

                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.circle_notifications_rounded,
                          size: 40,
                          color: !notification["read"]
                              ? Theme.of(context).primaryColor
                              : Colors.black26,
                        ),
                        title: Text(notification["message"]),
                        subtitle: Text(timeago.format(timeAgo)),
                      ),
                      const Divider()
                    ],
                  ));
                }).toList(),
              ));
        }

        return const SizedBox();
      }),
    );
  }
}
