import "package:flutter/material.dart";
import 'package:lesbeats/widgets/responsive.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({
    super.key,
  });

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  int selectedIndex = 0;

  Widget selectedScreen(index) {
    switch (index) {
      case 0:
        return Column(
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
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 4,
                  color: Colors.white,
                  child: Image.asset(
                    "assets/images/ecocash.png",
                    height: 50,
                    width: screenSize(context).width * 0.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                },
                child: Material(
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
              ),
            ]);
      case 1:
        return const MyMethod(
          number: "58527536",
          method: "MPESA",
        );
      case 2:
        return const MyMethod(
          number: "69050596",
          method: "ECOCASH",
        );
      case 3:
        return const MyMethod(
          number: "58527536",
          method: "CHAPERONE",
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: selectedScreen(selectedIndex)),
      ),
    );
  }
}

class MyMethod extends StatelessWidget {
  const MyMethod({super.key, required this.number, required this.method});
  final String method;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Follow these steps to deposit with $method",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "1. Send AMOUNT to $number (Katleho Nkoe)",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "2. Take a SCREENSHOT of confirmation message",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "3. Send screenshot and your EMAIL to WHATSAPP of the number above",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
