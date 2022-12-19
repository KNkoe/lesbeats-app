import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';
import '../../widgets/decoration.dart';

class MyDownload extends StatefulWidget {
  const MyDownload(
      {Key? key,
      required this.title,
      required this.id,
      required this.producer,
      required this.downloadUrl})
      : super(key: key);

  final String title;
  final String id;
  final String downloadUrl;
  final String producer;

  @override
  State<MyDownload> createState() => _MyDownloadState();
}

class _MyDownloadState extends State<MyDownload> {
  bool _isDownloading = false;
  double _progress = 0;

  Map<String, dynamic> download = {
    "uid": auth.currentUser!.uid,
    "timestamp": DateTime.now()
  };

  Future downloadAudio() async {
    try {
      final storageRef = storage.refFromURL(widget.downloadUrl);

      Directory directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = (await getExternalStorageDirectory())!;
      }

      final filePath = "${directory.path}/${widget.title}.mp3";

      debugPrint("FILE PATH :$filePath");

      final file = File(filePath);

      final downloadTask = storageRef.writeToFile(file);

      downloadTask.snapshotEvents.listen((event) {
        setState(() {
          _progress = ((event.bytesTransferred.toDouble() /
                      event.totalBytes.toDouble()) *
                  100)
              .roundToDouble();
        });
      });
    } catch (error) {
      debugPrint(error.toString());
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
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _isDownloading
          ? Column(
              children: [
                if (_progress != 100)
                  Lottie.network(
                      "https://assets3.lottiefiles.com/packages/lf20_pr5y4md7.json"),
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
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Download ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        _isDownloading
            ? OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: cancelButtonStyle,
                child: Text(_progress == 100 ? "Close" : "Hide"))
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isDownloading = true;
                  });

                  downloadAudio().whenComplete(() {
                    db
                        .collection("tracks")
                        .doc(widget.id)
                        .collection("downloads")
                        .doc(auth.currentUser!.uid)
                        .set(download);

                    db
                        .collection("users")
                        .doc(widget.producer)
                        .collection("notifications")
                        .add({
                      "message":
                          "${auth.currentUser!.displayName} downloaded ${widget.title}"
                    });
                  });
                },
                style: confirmButtonStyle,
                child: const Text("Download"))
      ],
    );
  }
}