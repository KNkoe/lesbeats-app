import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/screens/player/player.dart';
import 'package:lesbeats/widgets/decoration.dart';
import 'package:lesbeats/widgets/responsive.dart';

showUpload(BuildContext context) => showDialog(
    context: context,
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
  String imagename = "";

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imagename = image.name;
      });
    }
  }

  pickfile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        audio = file;
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

  final PageController _pageController = PageController();
  final TextEditingController _genreController = TextEditingController();

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

  String selectedGenre = "";
  bool _isGenreFocused = false;
  bool _isFree = false;
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return PageView(
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
                child: TextField(
                  decoration: dialogInputdecoration.copyWith(
                      label: const Text("Track name")),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: dialogInputdecoration.copyWith(
                      label: const Text("Artist")),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _genreController,
                  onChanged: ((value) {
                    setState(() {
                      _isGenreFocused = true;
                    });
                    _genreController.clear();
                  }),
                  decoration: dialogInputdecoration.copyWith(
                      prefix: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(selectedGenre),
                      ),
                      label: const Text("Genre")),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_isGenreFocused)
                Wrap(
                  children: genres
                      .map((genre) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedGenre = genre;
                                    _isGenreFocused = false;
                                  });
                                },
                                child: Text(genre)),
                          ))
                      .toList(),
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
              if (imagename != "")
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    imagename,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              const SizedBox(
                height: 20,
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
                    audio!.name,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.ease);
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
                child: TextField(
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
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Checkbox(
                      shape: const CircleBorder(),
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
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
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
                onPressed: () {},
                child: const Text("upload"))
          ],
        )
      ],
    );
  }
}
