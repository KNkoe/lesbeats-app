import 'dart:io';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/main.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

showUpload(BuildContext context) async {
  int count = 0;

  await db
      .collection("tracks")
      .where("artistId", isEqualTo: auth.currentUser!.uid)
      .get()
      .then((value) {
    count = value.size;
  });

  return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: count >= 30
                  ? AlertDialog(
                      title: Column(
                        children: [
                          Text(
                            "You have reached the maximum upload size of 30 beats. ",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Uploads more than 30 will be enabled for premium users. This is to be able to cover storage costs.",
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: cancelButtonStyle,
                            child: const Text("Close"))
                      ],
                    )
                  : const UploadBeat(),
            ),
          ));
}

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
      //Get AUDIO tags**title,feature,genre etc
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
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  SettableMetadata? _metadata;
  String? url;

  late final Stream<QuerySnapshot> _genreStream;

  @override
  void initState() {
    _genreStream = db.collection('genres').snapshots();
    super.initState();
  }

  String selectedGenre = "";
  String label = "Genre";
  bool _enableDownload = false;
  bool _agree = false;

// Upload the cover image to firebase storage
  Future<String?> uploadImage(String name, File path) async {
    String imagepath =
        "/tracks/${auth.currentUser!.uid}/${_tracknameController.text}/cover.${name.split(".").last}";
    try {
      await storage.ref(imagepath).putFile(
          path, SettableMetadata(contentType: "image/${name.split(".").last}"));

      final String coverUrl = await storage.ref(imagepath).getDownloadURL();

      return coverUrl;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  double _progress = 0;
// Upload the audio file to firebase storage
  uploadAudio(String name, File path) async {
    String audioPath =
        "/tracks/${auth.currentUser!.uid}/${_tracknameController.text}/${_tracknameController.text}.${name.split(".").last}";

    _metadata = SettableMetadata(customMetadata: {
      "title": _tracknameController.text,
      "feature": _featureController.text,
      "genre": selectedGenre
    });

    final UploadTask uploadTask =
        storage.ref(audioPath).putFile(path, _metadata);

    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        _progress =
            ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                    100)
                .roundToDouble();
      });
    });

    await uploadTask.then((tasksnapshot) async {
      if (tasksnapshot.state == TaskState.success) {
        await storage.ref(audioPath).getDownloadURL().then((value) {
          setState(() {
            url = value;
          });
        });
      }
    });
  }

  bool _isUploading = false;
// Upload the file information to firebase database
  Future<String?> upload() async {
    try {
      if (audio != null) {
        await uploadAudio(audio!.name, File(audio!.path!))
            .whenComplete(() async {
          final String cover =
              await storage.ref("/tracks/cover.jpg").getDownloadURL();

          final double price = double.parse(
              double.parse(_priceController.text).toStringAsFixed(2));

          db
              .collection("/tracks")
              .doc("${auth.currentUser!.uid}-${_tracknameController.text}")
              .set({
            "id": "${auth.currentUser!.uid}-${_tracknameController.text}",
            "artistId": auth.currentUser!.uid,
            "feature": _featureController.text,
            "title": _tracknameController.text,
            "genre": selectedGenre,
            "path": url,
            "cover": cover,
            "uploadedAt": DateTime.now(),
            "price": price,
            "download": _enableDownload,
          }, SetOptions(merge: true));
        });

        if (_image != null) {
          await uploadImage(_image!.path.split("/").last, _image!)
              .then((value) {
            if (value != null) {
              db
                  .collection("/tracks")
                  .doc("${auth.currentUser!.uid}-${_tracknameController.text}")
                  .set({
                "cover": value,
              }, SetOptions(merge: true));
            }
          });
        }
      }

      return "Success";
    } catch (error) {
      db
          .collection("/tracks")
          .doc("${auth.currentUser!.uid}-${_tracknameController.text}")
          .set({"success": false});
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
        message: error.toString(),
      ));
    }

    return null;
  }

  final Uri _url =
      Uri.parse('http://lesbeats.nicepage.io/Terms-and-conditions.html');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  var _openResult = 'Unknown';

  Future<void> openFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
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
                            labelText: "Track name",
                            labelStyle: Theme.of(context).textTheme.bodyText1),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _featureController,
                        decoration: dialogInputdecoration.copyWith(
                            labelText: "Feature",
                            labelStyle: Theme.of(context).textTheme.bodyText1),
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
                                        dropdownColor:
                                            Theme.of(context).backgroundColor,
                                        validator: (value) =>
                                            selectedGenre.isEmpty
                                                ? "Please select a genre"
                                                : null,
                                        value: snapshot.data!.docs[0]["title"],
                                        items: snapshot.data!.docs
                                            .map((genre) =>
                                                DropdownMenuItem<String>(
                                                    value: genre["title"],
                                                    child: Text(
                                                      genre["title"],
                                                    )))
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
                            openFile(audio!.path!);
                            debugPrint(_openResult);
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
                    ElevatedButton(
                        style: confirmButtonStyle,
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
                  title: StatefulBuilder(builder: (context, snapshot) {
                    return _isUploading
                        ? Column(
                            children: [
                              if (_progress != 100)
                                Lottie.network(
                                    "https://assets2.lottiefiles.com/packages/lf20_p1lpeyhh.json"),
                              if (_progress == 100)
                                Lottie.network(
                                    "https://assets10.lottiefiles.com/packages/lf20_qckmbbyi.json"),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${_progress.toInt().toString()}%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _progress != 100
                                        ? Theme.of(context).primaryColor
                                        : Colors.green),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              LinearProgressIndicator(
                                value: _progress * 0.01,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const Text("Upload your beat"),
                              SizedBox(
                                height: 30,
                                width: screenSize(context).width * 0.9,
                              ),
                              TextFormField(
                                enabled: !_enableDownload,
                                controller: _priceController,
                                // ignore: body_might_complete_normally_nullable
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    _priceController.text = 0.toString();
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                decoration: dialogInputdecoration.copyWith(
                                    prefixText: 'R ',
                                    prefixStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    label: const Text("Price")),
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
                                        fillColor: MaterialStateProperty.all(
                                            Theme.of(context).primaryColor),
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
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                child: Divider(),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      fillColor: MaterialStateProperty.all(
                                          Theme.of(context).primaryColor),
                                      value: _agree,
                                      onChanged: (value) {
                                        setState(() {
                                          _agree = value!;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  // const Text(
                                  //   "Agree to the",
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.normal, fontSize: 16),
                                  // ),
                                  InkWell(
                                    onTap: _launchUrl,
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        "Terms and Conditions",
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
                          );
                  }),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: _isUploading
                      ? [
                          if (_progress == 100)
                            OutlinedButton(
                                style: cancelButtonStyle,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close")),
                        ]
                      : [
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
                                if (_agree) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isUploading = true;
                                    });

                                    upload();
                                  }
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
                                        "You have to agree to our terms and conditions to continue",
                                  ));
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
