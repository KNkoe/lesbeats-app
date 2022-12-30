import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/format.dart';

import '../../widgets/decoration.dart';
import '../../widgets/responsive.dart';

showUpdate(BuildContext context, String id, double price) {
  showDialog(
      context: context,
      builder: ((context) => MyUpdateTrackScreen(id: id, price: price)));
}

class MyUpdateTrackScreen extends StatefulWidget {
  const MyUpdateTrackScreen({Key? key, required this.id, required this.price})
      : super(key: key);
  final String id;
  final double price;

  @override
  State<MyUpdateTrackScreen> createState() => _MyUpdateTrackScreenState();
}

class _MyUpdateTrackScreenState extends State<MyUpdateTrackScreen> {
  bool _isEditingPrice = false;
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Form(
        key: _key,
        child: Column(
          children: [
            const Text("Edit track info"),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price",
                  style: TextStyle(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditingPrice = true;
                    });
                  },
                  child: SizedBox(
                    height: 50,
                    width: screenSize(context).width,
                    child: TextFormField(
                      validator: ((value) {
                        if (!isNumeric(value!)) {
                          return "Input must be digits only";
                        }
                        return null;
                      }),
                      enabled: _isEditingPrice,
                      keyboardType: TextInputType.number,
                      controller: _priceController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: Text(widget.price.toString()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        OutlinedButton(
            style: cancelButtonStyle,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close")),
        ElevatedButton(
            style: confirmButtonStyle,
            onPressed: () async {
              if (_priceController.text.isNotEmpty) {
                await db.collection("tracks").doc(widget.id).set(
                    {"price": double.parse(_priceController.text)},
                    SetOptions(merge: true)).then((value) {
                  Get.showSnackbar(const GetSnackBar(
                    duration: Duration(seconds: 3),
                    backgroundColor: Color(0xff264653),
                    borderRadius: 30,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    message:
                        "Updated succesfully, You may need to refresh screen",
                  ));
                  Navigator.pop(context);
                });
              } else {
                Get.showSnackbar(const GetSnackBar(
                  duration: Duration(seconds: 3),
                  backgroundColor: Color(0xff264653),
                  borderRadius: 30,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  icon: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                  ),
                  message: "No updates applied",
                ));
                Navigator.pop(context);
              }
            },
            child: const Text("Update"))
      ],
    );
  }
}
