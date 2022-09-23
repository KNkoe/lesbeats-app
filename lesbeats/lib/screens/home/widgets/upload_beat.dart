import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/screens/home/player/player.dart';
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
      EasyLoading.showToast("Cancelled");
    }
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
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
              ElevatedButton.icon(
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
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            OutlinedButton.icon(
                icon: const Icon(Icons.arrow_forward_ios),
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.ease);
                },
                label: const Text("Next"))
          ],
        ),
        AlertDialog(
          title: Column(
            children: const [],
          ),
        )
      ],
    );
  }
}
