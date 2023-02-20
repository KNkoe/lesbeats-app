import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lottie/lottie.dart';

import '../decoration.dart';

class Checkout extends StatefulWidget {
  const Checkout(
      {super.key,
      required this.id,
      required this.price,
      required this.producer,
      required this.title,
      required this.producerID});
  final String id;
  final String title;
  final String producer;
  final double price;
  final String producerID;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double balance = 0.00;
  double producerBalance = 0.00;
  bool insufficient = false;

  Future getBalance() async {
    try {
      await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            balance = value.get("balance");
            insufficient = balance < widget.price;
          });
        }
      });

      await db.collection("users").doc(widget.producerID).get().then((value) {
        if (mounted) {
          setState(() {
            producerBalance = value.get("balance");
          });
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Title: ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(widget.title)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Producer: ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(widget.producer)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Price: ",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text("R ${widget.price}")
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (insufficient)
            Text(
              "You have insufficient funds! Balance: R${balance.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.red),
            ),
          const Divider(
            thickness: 1,
          ),
          const SizedBox(
            height: 20,
          ),
          if (!insufficient)
            ElevatedButton.icon(
                style: confirmButtonStyle.copyWith(
                    fixedSize: const MaterialStatePropertyAll(Size(200, 40))),
                onPressed: () {
                  if (balance > widget.price) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (context) => BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: ConfirmPayment(
                                id: widget.id,
                                price: widget.price,
                                title: widget.title,
                                producerID: widget.producerID,
                                balance: balance,
                                producerBalance: balance,
                              ),
                            ));
                  } else {
                    setState(() {
                      insufficient = true;
                    });
                  }
                },
                icon: const Icon(Icons.payment),
                label: const Text("Checkout"))
          else
            OutlinedButton(
                style: cancelButtonStyle,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"))
        ],
      ),
    );
  }
}

class ConfirmPayment extends StatefulWidget {
  const ConfirmPayment(
      {super.key,
      required this.id,
      required this.price,
      required this.title,
      required this.producerID,
      required this.balance,
      required this.producerBalance});
  final String id;
  final double price;
  final String title;
  final String producerID;
  final double balance;
  final double producerBalance;

  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Center(child: Text((loading) ? "Processing..." : "Confirm payment?")),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        if (!loading)
          OutlinedButton(
              style: cancelButtonStyle,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
        if (loading)
          Image.asset(
            "assets/images/loading.gif",
            height: 70,
            width: 70,
          )
        else
          ElevatedButton(
              style: confirmButtonStyle,
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                try {
                  await db
                      .collection("tracks")
                      .doc(widget.id)
                      .set({"sold": true, "purchasedBy": auth.currentUser!.uid},
                          SetOptions(merge: true))
                      .then((value) => db
                              .collection("users")
                              .doc(auth.currentUser!.uid)
                              .collection("transactions")
                              .add({
                            "title": "purchased (${widget.title})",
                            "type": "purchase",
                            "timestamp": DateTime.now(),
                            "amount": widget.price,
                            "status": "approved",
                            "method": "none",
                            "processed": true
                          }))
                      .then((value) => db
                              .collection("users")
                              .doc(widget.producerID)
                              .collection("transactions")
                              .add({
                            "title": "sold (${widget.title})",
                            "type": "sale",
                            "timestamp": DateTime.now(),
                            "amount": widget.price,
                            "status": "approved",
                            "method": "none",
                            "processed": true
                          }))
                      .then((value) => db.collection("users").doc(auth.currentUser!.uid).set(
                          {"balance": widget.balance - widget.price},
                          SetOptions(merge: true)))
                      .then((value) => db
                          .collection("users")
                          .doc(widget.producerID)
                          .set({"balance": widget.balance + widget.price}, SetOptions(merge: true)))
                      .then((value) {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: AlertDialog(
                                    title: Column(
                                      children: [
                                        Lottie.network(
                                            "https://assets10.lottiefiles.com/packages/lf20_qckmbbyi.json"),
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            "Purchase successful",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                        Text(
                                          "You can now download this beat anytime by clicking the options button next to the beat and clicking download",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        )
                                      ],
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      OutlinedButton(
                                          style: cancelButtonStyle,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Close"))
                                    ],
                                  ),
                                ));
                      });
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text("Confirm"))
      ],
    );
  }
}
