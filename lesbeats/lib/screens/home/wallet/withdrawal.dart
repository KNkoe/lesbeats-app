import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({
    super.key,
  });

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  int selectedIndex = 0;

  Widget selectedScreen(index) {
    switch (index) {
      case 0:
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                height: 20,
              ),
              const Text("Withdrawal method"),
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

class MyMethod extends StatefulWidget {
  const MyMethod({super.key, required this.number, required this.method});
  final String method;
  final String number;

  @override
  State<MyMethod> createState() => _MyMethodState();
}

class _MyMethodState extends State<MyMethod> {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _names = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loading = false;

  Future<void> _launchUrl(
      String amount, String number, String names, String method) async {
    String url =
        "https://wa.me/26669050596?text=${Uri.encodeFull("LESBEATS WITHDRAWAL\n\nNumber: $number\nMethod: $method\nAmount: $amount\nNames: $names")}";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch this Url';
    }
  }

  double balance = 0;

  Future updateBalance() async {
    await db.collection("users").doc(auth.currentUser!.uid).get().then((value) {
      balance = value.get("balance");
    });
  }

  @override
  void initState() {
    super.initState();
    updateBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: screenSize(context).width,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _amount,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Amount is required";
                      }
                      try {
                        if (double.parse(value) < 30) {
                          return "Minimum withdrawal is R30";
                        }

                        if (balance < double.parse(value) || balance == 0) {
                          return "You have unsufficient funds. Balance: R$balance";
                        }
                      } catch (e) {
                        return "Invalid amount";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: Text("AMOUNT"),
                        prefixText: "R "),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: screenSize(context).width,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Number is required";
                      }

                      if (value.length != 8) {
                        return "Invalid number";
                      }

                      try {
                        double.parse(value);
                      } catch (e) {
                        return "Invalid number";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: Text("${widget.method} NUMBER"),
                        prefixText: "+266 "),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: screenSize(context).width,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _names,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Names are required";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      label: Text("NAMES"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                loading
                    ? Image.asset(
                        "assets/images/loading.gif",
                        height: 70,
                        width: 70,
                      )
                    : ElevatedButton(
                        style: confirmButtonStyle,
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });

                            _launchUrl(_amount.text, _number.text, _names.text,
                                widget.method);

                            db
                                .collection("users")
                                .doc(auth.currentUser!.uid)
                                .set({}, SetOptions(merge: true));

                            db
                                .collection("users")
                                .doc(auth.currentUser!.uid)
                                .collection("transactions")
                                .add({
                              "title": "withdrawal (${widget.method})",
                              "type": "withdrawal",
                              "timestamp": DateTime.now(),
                              "amount": double.parse(_amount.text),
                              "status": "pending",
                              "method": widget.method,
                              "processed": false
                            }).then((value) => Navigator.pop(context));
                          }
                        },
                        child: const Text("Withdraw")),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Disclaimer",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "Withdrawals on this app are only available to verified users. This is to help identify users who may have sold copyrighted beats. By using this app, you agree to comply with all laws and regulations related to the use of copyrighted material. Any violation of these policies may result in account suspension or termination, as well as potential legal action against the you. ")
              ],
            ),
          ),
        ),
      ],
    );
  }
}
