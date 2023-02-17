import 'package:flutter/material.dart';

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
      ),
      body: Padding(
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
                Row(
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
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "R 167.00",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        fixedSize: const Size.fromWidth(100)),
                    child: const Text("Deposit")),
                const SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                    onPressed: () {},
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
              "Transactions",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100]),
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                  title: const Text("Vicious_Kadd bought Lerato"),
                  subtitle: const Text("20/02/2022 - 21:00"),
                  trailing: const Text(
                    "+R 150",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100]),
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.red,
                    ),
                  ),
                  title: const Text("Withdrawal"),
                  subtitle: const Text("20/02/2022 - 20:00"),
                  trailing: const Text(
                    "-R 150",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
