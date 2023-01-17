import "package:flutter/material.dart";
import 'package:lesbeats/services/payment.dart';

showcheckout(BuildContext context) {
  showModalBottomSheet(
      context: context, builder: ((context) => const CheckOutScreen()));
}

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var response = await Payment()
                      .get("api")
                      .catchError((error) => debugPrint(error));

                  if (response == null) return;

                  debugPrint("Successful");
                },
                child: const Text("Chapreone"))
          ],
        ),
      ),
    );
  }
}
