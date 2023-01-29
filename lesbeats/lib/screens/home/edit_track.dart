import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _titleController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool _enableDownload = false;

  @override
  void initState() {
    super.initState();
    db.collection("tracks").doc(widget.id).get().then((value) {
      setState(() {
        _enableDownload = value.get("download");
      });
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
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
                  "Title",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 50,
                  width: screenSize(context).width,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _titleController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      label: Text("Title"),
                    ),
                  ),
                ),
              ],
            ),
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
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _enableDownload = !_enableDownload;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                          shape: const CircleBorder(),
                          value: _enableDownload,
                          onChanged: (value) {
                            setState(() {
                              _enableDownload = value!;

                              if (_enableDownload) {
                                _priceController.clear();
                              }
                            });
                          }),
                      const SizedBox(
                        width: 4,
                      ),
                      const Text(
                        "Enable download",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      )
                    ],
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
              try {
                if (_priceController.text.isNotEmpty) {
                  await db.collection("tracks").doc(widget.id).set(
                      {"price": double.parse(_priceController.text)},
                      SetOptions(merge: true));
                }

                if (_titleController.text.isNotEmpty) {
                  await db.collection("tracks").doc(widget.id).set(
                      {"title": _titleController.text},
                      SetOptions(merge: true));
                }

                await db.collection("tracks").doc(widget.id).set(
                    {"download": _enableDownload},
                    SetOptions(
                        merge: true)).then((value) => Navigator.pop(context));
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            child: const Text("Update"))
      ],
    );
  }
}
