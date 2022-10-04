import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

editprofile(BuildContext context) {
  showDialog(context: context, builder: ((context) => const EditProfile()));
}

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isUsernameEnabled = false;

  final Stream<DocumentSnapshot> _userStream =
      db.collection("users").doc(auth.currentUser!.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: AlertDialog(
              title: Column(
                children: [
                  const Text("Edit profile"),
                  SizedBox(
                    height: 30,
                    width: Get.width * 0.9,
                  ),
                  CircleAvatar(
                    minRadius: 50,
                    backgroundImage: const AssetImage("assets/images/rnb.jpg"),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 50,
                        width: Get.width * 0.5,
                        child: TextFormField(
                          enabled: _isUsernameEnabled,
                          keyboardType: TextInputType.name,
                          validator: Validators.compose([
                            (value) => value!.isEmpty
                                ? "Please enter your username"
                                : null,
                            (value) => value!.contains(" ")
                                ? "User name must not contain spaces"
                                : null
                          ]),
                          controller: _usernameController,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            label: Text(snapshot.data!["username"].toString()),
                          ),
                        ),
                      ),
                      Material(
                          color: Theme.of(context).primaryColor,
                          shape: const CircleBorder(),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isUsernameEnabled = !_isUsernameEnabled;
                                });
                              },
                              icon: const Icon(Icons.edit)))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      validator: Validators.compose([
                        (value) => value!.isEmpty
                            ? "Please enter your username"
                            : null,
                        (value) => value!.contains(" ")
                            ? "User name must not contain spaces"
                            : null
                      ]),
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: Text("Username"),
                      ),
                    ),
                  )
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                OutlinedButton(
                    style: cancelButtonStyle,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    style: confirmButtonStyle,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Save"))
              ],
            ),
          );
        });
  }
}
