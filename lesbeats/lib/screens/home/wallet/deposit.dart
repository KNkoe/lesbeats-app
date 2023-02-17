import "package:flutter/material.dart";
import 'package:lesbeats/widgets/responsive.dart';

showDeposit(BuildContext context, String title, double price, String id,
    String uid, String producer) {
  showModalBottomSheet(
      context: context,
      builder: ((context) => DepositScreen(
            id: id,
            uid: uid,
            price: price,
            title: title,
            producer: producer,
          )));
}

class DepositScreen extends StatefulWidget {
  const DepositScreen(
      {super.key,
      required this.id,
      required this.price,
      required this.uid,
      required this.title,
      required this.producer});
  final String id;
  final String uid;
  final String title;
  final double price;
  final String producer;

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              const SizedBox(
                height: 20,
              ),
              const Text("Payment method"),
              SizedBox(
                height: screenSize(context).height * 0.1,
              ),
              GestureDetector(
                onTap: () {},
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 4,
                  color: const Color(0xffe00000),
                  child: Image.asset(
                    "assets/images/mpesa.jpeg",
                    height: 50,
                    width: screenSize(context).width * 0.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 4,
                color: Colors.white,
                child: Image.asset(
                  "assets/images/ecocash.png",
                  height: 50,
                  width: screenSize(context).width * 0.5,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 4,
                color: Colors.white,
                child: SizedBox(
                  height: 50,
                  width: screenSize(context).width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/chapreone.png",
                    ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
