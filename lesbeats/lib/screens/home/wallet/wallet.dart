import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/load.dart';
import 'package:lottie/lottie.dart';

import 'deposit.dart';
import 'withdrawal.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "My Wallet",
          style: Theme.of(context).textTheme.titleLarge!,
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db.collection("users").doc(auth.currentUser!.uid).snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  "assets/images/loading.gif",
                  height: 70,
                  width: 70,
                ),
              );
            }

            if (userSnapshot.hasData) {
              double balance = 0.00;

              try {
                balance =
                    double.parse(userSnapshot.data!.get("balance").toString());
              } catch (e) {
                debugPrint(e.toString());
              }

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Balance",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => const DepositScreen());
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Topup",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "R ${balance.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const DepositScreen());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                fixedSize: const Size.fromWidth(100)),
                            child: const Text("Deposit")),
                        const SizedBox(
                          width: 20,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      const WithdrawalScreen());
                            },
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                fixedSize: const Size.fromWidth(100)),
                            child: const Text("Withdraw"))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Transaction history",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: db
                            .collection("users")
                            .doc(auth.currentUser!.uid)
                            .collection("transactions")
                            .orderBy("timestamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const TransactionLoading();
                          }

                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.network(
                                      "https://assets7.lottiefiles.com/packages/lf20_rc6CDU.json",
                                    ),
                                    const Text("No transactions")
                                  ],
                                ),
                              );
                            }

                            return Expanded(
                                child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                String title = "";
                                Timestamp timestamp = Timestamp.now();
                                String type = "";
                                String status = "";
                                double amount = 0.0;
                                bool processed = false;

                                try {
                                  title =
                                      snapshot.data!.docs[index].get("title");
                                  timestamp = snapshot.data!.docs[index]
                                      .get("timestamp");
                                  type = snapshot.data!.docs[index].get("type");
                                  status =
                                      snapshot.data!.docs[index].get("status");
                                  amount =
                                      snapshot.data!.docs[index].get("amount");
                                  processed = snapshot.data!.docs[index]
                                      .get("processed");

                                  if (status == "approved" &&
                                      processed == false) {
                                    if (type == "deposit" || type == "sale") {
                                      userSnapshot.data!.reference.set({
                                        "balance": balance + amount,
                                      }, SetOptions(merge: true));

                                      snapshot.data!.docs[index].reference.set(
                                          {"processed": true},
                                          SetOptions(merge: true));
                                    }
                                    if (type == "withdrawal" ||
                                        type == "purchase") {
                                      userSnapshot.data!.reference.set({
                                        "balance": balance - amount,
                                      }, SetOptions(merge: true));

                                      snapshot.data!.docs[index].reference.set(
                                          {"processed": true},
                                          SetOptions(merge: true));
                                    }
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                }

                                final date =
                                    timestamp.toDate().toString().split(" ")[0];
                                final time = timestamp
                                    .toDate()
                                    .toString()
                                    .split(" ")[1]
                                    .substring(0, 5);

                                return ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100]),
                                    child: Icon(
                                      Icons.attach_money,
                                      color:
                                          (type == "deposit" || type == "sale")
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  title: Text(title),
                                  subtitle: Text("$date | $time"),
                                  trailing: (status == "pending" ||
                                          status == "declined")
                                      ? Text(
                                          status,
                                          style: TextStyle(
                                              color: status == "declined"
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor),
                                        )
                                      : Text(
                                          (type == "deposit" || type == "sale")
                                              ? "+R ${amount.toStringAsFixed(2)}"
                                              : "-R ${amount.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              color: (type == "deposit" ||
                                                      type == "sale")
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                );
                              },
                            ));
                          }
                          return const SizedBox();
                        })
                  ],
                ),
              );
            }

            return const SizedBox();
          }),
    );
  }
}
