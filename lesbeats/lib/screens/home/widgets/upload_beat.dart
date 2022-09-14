import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesbeats/widgets/decoration.dart';

showUpload(BuildContext context) => showDialog(
    context: context,
    builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: const UploadBeat(),
        ));

class UploadBeat extends StatefulWidget {
  const UploadBeat({
    Key? key,
  }) : super(key: key);

  @override
  State<UploadBeat> createState() => _UploadBeatState();
}

class _UploadBeatState extends State<UploadBeat> {
  String filename = "";
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
        filename = file.name;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Upload your beat"),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 50,
            child: TextField(
              decoration: dialogInputdecoration.copyWith(
                  label: const Text("Track name")),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: TextField(
              decoration:
                  dialogInputdecoration.copyWith(label: const Text("Artist")),
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
          if (filename != "")
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                filename,
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
        ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward_ios),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {},
            label: const Text("Next"))
      ],
    );
  }
}
