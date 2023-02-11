import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/responsive.dart';

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isUsernameEnabled = false;
  bool _isnameEnabled = false;
  bool _ispasswordEnabled = false;
  bool _isImageChanged = false;
  bool _isSaving = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final Stream<DocumentSnapshot> _userStream =
      db.collection("users").doc(auth.currentUser!.uid).snapshots();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _imageName;
  File? _imagePath;

// pick file from device storage
  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);

    if (image != null) {
      File photo = File(image.path);
      _imageName = image.path;
      _imagePath = photo;
      debugPrint(image.path);

      setState(() {
        _isImageChanged = true;
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
        message: "Canceled",
      ));
    }
  }

// Upload image to firebase storage
  upload(String name, File path) async {
    String imagepath =
        "/users/${auth.currentUser!.uid}/profilePicture.${name.split(".").last}";
    try {
      await storage.ref(imagepath).putFile(
          path, SettableMetadata(contentType: "image/${name.split(".").last}"));

      final String url = await storage.ref(imagepath).getDownloadURL();

      await auth.currentUser!.updatePhotoURL(url);
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .set({"photoUrl": url}, SetOptions(merge: true));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Update profile info in firebase database
  Future<String?> updateProfileInfo() async {
    setState(() {
      _isSaving = true;
    });

    try {
      if (_isnameEnabled && _nameController.text.isNotEmpty) {
        db
            .collection("users")
            .doc(auth.currentUser!.uid)
            .set({"full name": _nameController.text}, SetOptions(merge: true));
      }
      if (_isUsernameEnabled && _usernameController.text.isNotEmpty) {
        await auth.currentUser!.updateDisplayName(_usernameController.text);
        db.collection("users").doc(auth.currentUser!.uid).set(
            {"username": _usernameController.text}, SetOptions(merge: true));
      }
      if (_ispasswordEnabled && _passwordController.text.isNotEmpty) {
        await auth.currentUser!.updatePassword(_passwordController.text);
      }
      if (_imagePath != null) {
        upload(_imageName!.split("/").last, _imagePath!);
      }

      setState(() {
        _isSaving = false;
      });

      return "Success";
    } catch (error) {
      Get.showSnackbar(GetSnackBar(
        isDismissible: true,
        duration: const Duration(seconds: 5),
        backgroundColor: const Color(0xff264653),
        borderRadius: 30,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        message: error.toString().split("]")[1],
      ));
    }

    setState(() {
      _isSaving = false;
    });
    return null;
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

            if (snapshot.hasData) {
              return Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    title: Column(
                      children: [
                        const Text("Edit profile"),
                        SizedBox(
                          height: 30,
                          width: screenSize(context).width * 0.9,
                        ),
                        _isImageChanged
                            ? GestureDetector(
                                onTap: pickImage,
                                child: ClipOval(
                                  child: Image.file(
                                    _imagePath!,
                                    fit: BoxFit.fill,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Full Name",
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isnameEnabled = true;
                                });
                              },
                              child: SizedBox(
                                height: 50,
                                width: screenSize(context).width,
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
                              "username",
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isUsernameEnabled = true;
                                });
                              },
                              child: SizedBox(
                                height: 50,
                                width: screenSize(context).width,
                                child: TextFormField(
                                  enabled: _isUsernameEnabled,
                                  keyboardType: TextInputType.name,
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
                              "Password",
                              style: TextStyle(fontSize: 14),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _ispasswordEnabled = true;
                                });
                              },
                              child: SizedBox(
                                height: 50,
                                width: screenSize(context).width,
                                child: TextFormField(
                                    enabled: _ispasswordEnabled,
                                    keyboardType: TextInputType.name,
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        label: const Text("Change Password"),
                                        hintText: "New Password",
                                        suffix: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons
                                                      .remove_red_eye_outlined
                                                  : Icons.remove_red_eye,
                                              color: Colors.black38,
                                            )))),
                              ),
                            ),
                          ],
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
                            child: SizedBox(
                              height: 50,
                              width: screenSize(context).width,
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirm,
                                validator: (value) =>
                                    value != _passwordController.text
                                        ? "Passwords do not match"
                                        : null,
                                decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: const Text("Confirm Password"),
                                    suffix: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirm = !_obscureConfirm;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureConfirm
                                              ? Icons.remove_red_eye_outlined
                                              : Icons.remove_red_eye,
                                          color: Colors.black38,
                                        ))),
                              ),
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
                              updateProfileInfo().then((value) {
                                if (value == "Success") {
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
                                    message: "Profile updated successfully",
                                  ));
                                }
                              });
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
              );
            }

            return const SizedBox();
          }),
    );
  }
}
