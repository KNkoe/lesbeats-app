import 'dart:io';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/screens/player/player.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:audiotagger/audiotagger.dart';

showUpload(BuildContext context) => showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: const UploadBeat(),
          ),
        ));

class UploadBeat extends StatefulWidget {
  const UploadBeat({
    Key? key,
  }) : super(key: key);

  @override
  State<UploadBeat> createState() => _UploadBeatState();
}

class _UploadBeatState extends State<UploadBeat> {
  PlatformFile? audio;
  File? _image;
  bool _isImageChanged = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? title;

  final tagger = Audiotagger();

  getTags() async {
    final String filePath = audio!.path!;
    final Tag? tag = await tagger.readTags(path: filePath);

    setState(() {
      title = tag!.title;
    });
  }

//Pick image for the art cover
  pickImage() async {
    final ImagePicker picker = ImagePicker();
    //Pick image the resize it to limit storage consumption
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);

    if (image != null) {
      File photo = File(image.path);
      _image = photo;
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

//Pick audio file from device storage
  pickfile() async {
    //Limit selection to MP3
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        audio = file;
      });
      //Get AUDIO tags**title,artist,genre etc
      getTags();
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

  final PageController _pageController = PageController();
  final TextEditingController _tracknameController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  SettableMetadata? _metadata;

  late final Stream<QuerySnapshot> _genreStream;

  @override
  void initState() {
    _genreStream = db.collection('genres').snapshots();
    super.initState();
  }

  String selectedGenre = "";
  String label = "Genre";
  bool _isFree = false;
  bool _enableDownload = false;
  bool _agree = false;
  String _url = "";
  String _coverUrl = "";

// Upload the cover image to firebase storage
  uploadImage(String name, File path) async {
    String imagepath =
        "/users/${auth.currentUser!.uid}/${_tracknameController.text}/cover.${name.split(".").last}";
    try {
      await storage.ref(imagepath).putFile(
          path, SettableMetadata(contentType: "image/${name.split(".").last}"));

      _coverUrl = await storage.ref(imagepath).getDownloadURL();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double _progress = 0;
// Upload the audio file to firebase storage
  uploadAudio(String name, File path) async {
    String audioPath =
        "/users/${auth.currentUser!.uid}/${_tracknameController.text}/${_tracknameController.text}.${name.split(".").last}";
    try {
      _metadata = SettableMetadata(customMetadata: {
        "title": _tracknameController.text,
        "artist": _artistController.text,
        "genre": selectedGenre
      });

      storage
          .ref(audioPath)
          .putFile(path, _metadata)
          .snapshotEvents
          .listen((event) {
        setState(() {
          _progress =
              ((event.bytesTransferred.toDouble() / event.totalBytes) * 100)
                  .roundToDouble();
        });
      });

      _url = await storage.ref(audioPath).getDownloadURL();

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool _isUploading = false;
// Upload the file information to firebase database
  Future<String?> upload() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (_image != null) {
        uploadImage(_image!.path.split("/").last, _image!);
      }

      if (audio != null) {
        uploadAudio(audio!.name, File(audio!.path!));
      }

      db.collection("/tracks").add({
        "artistId": auth.currentUser!.uid,
        "title": _tracknameController.text,
        "path": _url,
        "uploadedAt": DateTime.now(),
        "price": _isFree ? 0 : _priceController.text,
        "free": _isFree,
        "download": _enableDownload,
        "cover": _coverUrl
      });

      setState(() {
        _isUploading = false;
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

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: screenSize(context).width,
            height: screenSize(context).height,
            child: PageView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Upload your beat"),
                      SizedBox(
                        height: 30,
                        width: screenSize(context).width * 0.9,
                      ),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? "Please enter track name" : null,
                        controller: _tracknameController,
                        decoration: dialogInputdecoration.copyWith(
                            label: const Text("Track name")),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _artistController,
                        validator: (value) =>
                            value!.isEmpty ? "Please enter artist name" : null,
                        decoration: dialogInputdecoration.copyWith(
                            label: const Text("Artist")),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("Genre"),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: screenSize(context).width * 0.5,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _genreStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasData) {
                                    return DropdownButtonFormField<String>(
                                        validator: (value) =>
                                            selectedGenre.isEmpty
                                                ? "Please select a genre"
                                                : null,
                                        value: snapshot.data!.docs[0]["title"],
                                        items: snapshot.data!.docs
                                            .map((genre) =>
                                                DropdownMenuItem<String>(
                                                    value: genre["title"],
                                                    child:
                                                        Text(genre["title"])))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGenre = value!;
                                          });
                                        });
                                  }

                                  return const SizedBox();
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          icon: const Icon(Icons.photo),
                          onPressed: () {
                            pickImage();
                          },
                          label: const Text("Select cover")),
                      if (_isImageChanged)
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: OpenContainer(
                              closedElevation: 0,
                              openElevation: 0,
                              closedBuilder: ((context, action) => Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12)),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                      height: 30,
                                      width: 30,
                                    ),
                                  )),
                              openBuilder: ((context, action) => Image.file(
                                    _image!,
                                    height: screenSize(context).height * 0.6,
                                    width: screenSize(context).width,
                                  )),
                            )),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          icon: const Icon(Icons.audio_file),
                          onPressed: () {
                            pickfile();
                          },
                          label: const Text("Select audio")),
                      const SizedBox(
                        height: 10,
                      ),
                      if (audio != null)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.play_circle),
                          onPressed: () {
                            showPlayer(context, audio!);
                          },
                          label: Text(
                            title == null
                                ? audio!.name
                                : title!.isEmpty
                                    ? audio!.name
                                    : title!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
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
                    OutlinedButton(
                        style: cancelButtonStyle,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (audio != null) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 750),
                                  curve: Curves.ease);
                            } else {
                              Get.showSnackbar(const GetSnackBar(
                                duration: Duration(seconds: 3),
                                backgroundColor: Color(0xff264653),
                                borderRadius: 30,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                icon: Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                                message:
                                    "No audio is selected, please select an audio(MP3) file",
                              ));
                            }
                          }
                        },
                        child: const Text("Next"))
                  ],
                ),
                AlertDialog(
                  title: Column(
                    children: [
                      const Text("Upload your beat"),
                      SizedBox(
                        height: 30,
                        width: screenSize(context).width * 0.9,
                      ),
                      TextFormField(
                        controller: _priceController,
                        validator: (value) => value!.isEmpty
                            ? "Please enter the price or click FREE"
                            : null,
                        keyboardType: TextInputType.phone,
                        enabled: !_isFree,
                        decoration: dialogInputdecoration.copyWith(
                            prefixText: 'R ', label: const Text("Price")),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              shape: const CircleBorder(),
                              value: _isFree,
                              onChanged: (value) {
                                setState(() {
                                  _isFree = value!;
                                });
                              }),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(
                            "Free",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              shape: const CircleBorder(),
                              value: _enableDownload,
                              onChanged: (value) {
                                setState(() {
                                  _enableDownload = value!;
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
                      const SizedBox(
                        height: 20,
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: _agree,
                              onChanged: (value) {
                                setState(() {
                                  _agree = value!;
                                });
                              }),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(
                            "Agree to the",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "terms and conditions",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                    fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    OutlinedButton(
                        style: cancelButtonStyle,
                        onPressed: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 750),
                              curve: Curves.ease);
                        },
                        child: const Text("Back")),
                    ElevatedButton(
                        style: confirmButtonStyle,
                        onPressed: () {
                          if (!_agree) {
                            Get.showSnackbar(const GetSnackBar(
                              duration: Duration(seconds: 3),
                              backgroundColor: Color(0xff264653),
                              borderRadius: 30,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              icon: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              ),
                              message:
                                  "You have to agree to our terms and conditions to continue",
                            ));
                          }
                          if (!_isFree) {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              upload().then((value) {
                                if (value != null) {
                                  if(_isUploading){
                                    showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            title: LinearProgressIndicator(
                                              value: _progress,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )));
                                  }
                                }
                              });
                            }
                          }
                        },
                        child: const Text("upload"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
