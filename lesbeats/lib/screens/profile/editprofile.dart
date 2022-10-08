import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _isUsernameEnabled = false;
  bool _isnameEnabled = false;
  bool _ispasswordEnabled = false;
  bool _isImageChanged = false;
  bool _isSaving = false;

  final Stream<DocumentSnapshot> _userStream =
      db.collection("users").doc(auth.currentUser!.uid).snapshots();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String? _imageName;
  File? _imagePath;

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);

    if (image != null) {
      File photo = File(image.path);
      _imageName = image.path;
      _imagePath = photo;
      debugPrint(image.path);
    }

    setState(() {
      _isImageChanged = true;
    });
  }

  upload(String name, File path) async {
    String imagepath =
        "/users/${auth.currentUser!.uid}/profilePicture.${name.split(".").last}";
    try {
      await storage.ref(imagepath).putFile(
          path, SettableMetadata(contentType: "image/${name.split(".").last}"));

      final String url = await storage.ref(imagepath).getDownloadURL();

      auth.currentUser!.updatePhotoURL(url);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateProfileInfo() {
    setState(() {
      _isSaving = true;
    });
    if (_isnameEnabled && _nameController.text.isNotEmpty) {
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set({"full name": _nameController.text});
    }
    if (_isUsernameEnabled && _usernameController.text.isNotEmpty) {
      auth.currentUser!.updateDisplayName(_usernameController.text);
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set({"username": _usernameController.text});
    }
    if (_isnameEnabled && _passwordController.text.isNotEmpty) {
      auth.currentUser!.updatePassword(_nameController.text);
    }
    upload(_imageName!.split("/").last, _imagePath!);
    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: StreamBuilder<DocumentSnapshot>(
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
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    title: Column(
                      children: [
                        const Text("Edit profile"),
                        SizedBox(
                          height: 30,
                          width: Get.width * 0.9,
                        ),
                        _isImageChanged
                            ? GestureDetector(
                                onTap: pickImage,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    _imagePath!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: pickImage,
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            auth.currentUser!.photoURL!)),
                                  ),
                                  child: Icon(Icons.camera_alt,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: Get.width * 0.5,
                              child: TextFormField(
                                enabled: _isnameEnabled,
                                keyboardType: TextInputType.name,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  label: Text(
                                      snapshot.data!["full name"].toString()),
                                ),
                              ),
                            ),
                            if (!_isnameEnabled)
                              Material(
                                  color: Theme.of(context).primaryColor,
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isnameEnabled = true;
                                        });
                                      },
                                      icon: const Icon(Icons.edit)))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: Get.width * 0.5,
                              child: TextFormField(
                                enabled: _isUsernameEnabled,
                                keyboardType: TextInputType.name,
                                validator: Validators.compose([
                                  (value) => value!.contains(" ")
                                      ? "User name must not contain spaces"
                                      : null
                                ]),
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  label: Text(snapshot.data!["username"]),
                                ),
                              ),
                            ),
                            if (!_isUsernameEnabled)
                              Material(
                                  color: Theme.of(context).primaryColor,
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isUsernameEnabled = true;
                                        });
                                      },
                                      icon: const Icon(Icons.edit)))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _ispasswordEnabled = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                width: Get.width * 0.5,
                                child: TextFormField(
                                  enabled: _ispasswordEnabled,
                                  keyboardType: TextInputType.name,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: Text("Change Password"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_ispasswordEnabled)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _ispasswordEnabled = true;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: Get.width * 0.5,
                                  child: TextFormField(
                                    enabled: _ispasswordEnabled,
                                    keyboardType: TextInputType.name,
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      label: Text("Confirm Password"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
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
                            if (_formKey.currentState!.validate()) {
                              updateProfileInfo();
                              Navigator.of(context).pop();
                              Get.showSnackbar(const GetSnackBar(
                                duration: Duration(seconds: 3),
                                backgroundColor: Color(0xff264653),
                                borderRadius: 30,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                message: "Profile update successfully",
                              ));
                            }
                          },
                          child: _isSaving
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text("Save"))
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
