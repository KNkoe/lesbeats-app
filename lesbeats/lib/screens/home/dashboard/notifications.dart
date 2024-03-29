import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/format.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyNotifications extends StatefulWidget {
  const MyNotifications({super.key});

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  int unread = 0;

  @override
  void didChangeDependencies() {
    try {
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("notifications")
          .where("read", isEqualTo: false)
          .snapshots()
          .listen(
        (event) {
          if (mounted) {
            setState(() {
              unread = event.size;
            });
          }
        },
      );
    } catch (e) {
      debugPrint("NOTIFICATION: $e");
    }
    listenForNotifications();
    super.didChangeDependencies();
  }

  void listenForNotifications() async {
    final fcmToken = await messaging.getToken();

    debugPrint(fcmToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        try {
          final pushNotification = {
            "title": message.notification!.title,
            "message": message.notification!.body,
            "timestamp": DateTime.now(),
            "read": false,
            "type": message.notification!.title,
            "url": message.notification!.web?.link,
          };
          db
              .collection("users")
              .doc(auth.currentUser!.uid)
              .collection("notifications")
              .add(pushNotification);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(unread.toString());
    return StreamBuilder(
      stream: db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("notifications")
          .orderBy("timestamp", descending: true)
          .snapshots(),
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
                    isLabelVisible: unread != 0,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    label: Text(
                      numberFormat(unread),
                    ),
                    child: const Icon(Icons.notifications)),
                itemBuilder: (context) =>
                    snapshot.data!.docs.map((notification) {
                  Timestamp timestamp = notification["timestamp"];

                  final timeDifference =
                      DateTime.now().difference(timestamp.toDate());

                  final timeAgo = DateTime.now().subtract(timeDifference);

                  return PopupMenuItem(
                      child: Dismissible(
                    onDismissed: (direction) {
                      notification.reference.delete();
                    },
                    key: Key(notification.id),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            setState(() {
                              if (!notification["read"]) {
                                Future.delayed(
                                    Duration.zero,
                                    () => notification.reference.set(
                                        {"read": true},
                                        SetOptions(merge: true)));
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
                    ),
                  ));
                }).toList(),
              ));
        }

        return const SizedBox();
      }),
    );
  }
}
