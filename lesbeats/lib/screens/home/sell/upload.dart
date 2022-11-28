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
import 'package:wc_form_validators/wc_form_validators.dart';

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
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _tracknameController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  SettableMetadata? _metadata;

  List<String> genres = [
    "Amapiano",
    "Afrobeat",
    "Dance",
    "Hiphop",
    "Trap",
    "House",
    "Famo",
    "Rock",
    "Pop",
    "Deep House",
    "Other"
  ];

  late final Stream<QuerySnapshot> _genreStream;

  @override
  void initState() {
    _genreStream = db.collection('genres').snapshots();
    super.initState();
  }

  String selectedGenre = "";
  String label = "Genre";
  bool _isGenreFocused = false;
  bool _isFree = false;
  bool _agree = false;

// Upload the cover image to firebase storage
  uploadImage(String name, File path) async {
    String imagepath =
        "/users/${auth.currentUser!.uid}/${_tracknameController.text}/cover.${name.split(".").last}";
    try {
      await storage.ref(imagepath).putFile(
          path, SettableMetadata(contentType: "image/${name.split(".").last}"));
    } catch (e) {
      debugPrint(e.toString());
    }
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
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          validator: Validators.compose([
                            (value) => value!.isEmpty
                                ? "Please enter track name"
                                : null
                          ]),
                          controller: _tracknameController,
                          decoration: dialogInputdecoration.copyWith(
                              label: const Text("Track name")),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _artistController,
                          validator: Validators.compose([
                            (value) => value!.isEmpty
                                ? "Please enter artist name"
                                : null
                          ]),
                          decoration: dialogInputdecoration.copyWith(
                              label: const Text("Artist")),
                        ),
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
                                        validator: Validators.compose([
                                          (value) => selectedGenre.isEmpty
                                              ? "Please select a genre"
                                              : null
                                        ]),
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
                      if (_isGenreFocused)
                        StreamBuilder<QuerySnapshot>(
                            stream: _genreStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                );
                              } else if (snapshot.hasData) {
                                return Wrap(
                                    children: snapshot.data!.docs
                                        .map((genre) => Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: OutlinedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedGenre =
                                                          genre["title"];
                                                      label = selectedGenre;
                                                      _isGenreFocused = false;
                                                    });
                                                  },
                                                  child: Text(genre['title'])),
                                            ))
                                        .toList());
                              }

                              return const SizedBox();
                            }),
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
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.ease);
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
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _priceController,
                          validator: (value) => value!.isEmpty
                              ? "Please enter the price or click FREE"
                              : null,
                          keyboardType: TextInputType.phone,
                          enabled: !_isFree,
                          decoration: dialogInputdecoration.copyWith(
                              prefixText: 'R ', label: const Text("Price")),
                        ),
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
                      const SizedBox(
                        height: 20,
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
                            if (_formKey.currentState!.validate()) {}
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
