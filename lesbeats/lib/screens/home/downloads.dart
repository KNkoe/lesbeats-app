import 'dart:io';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class MyDownloads extends StatefulWidget {
  const MyDownloads({super.key});

  @override
  State<MyDownloads> createState() => _MyDownloadsState();
}

class _MyDownloadsState extends State<MyDownloads> {
  Directory directory = Directory('/storage/emulated/0/Download');
  List<FileSystemEntity> files = [];
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    if (!await directory.exists()) {
      directory = (await getExternalStorageDirectory())!;
    }

    setState(() {
      if (Directory(directory.path).path.isNotEmpty) {
        files = io.Directory(directory.path).listSync();
        debugPrint("LENGTH ${files.length}");
      }
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Downloads",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.headline6!.color,
        ),
      ),
      body: files.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                      "https://assets1.lottiefiles.com/private_files/lf30_e3pteeho.json"),
                  const Text("No downloads")
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: files.length,
              itemBuilder: (BuildContext context, int index) {
                String file =
                    files[index].toString().split("/").last.split("'").first;
                if (file.contains("Lesbeats")) {
                  return ListTile(
                    onTap: () {
                      openFile("/storage/emulated/0/Download/$file");

                      debugPrint(_openResult);
                    },
                    leading: const Icon(Icons.music_note),
                    title: Text(files[index].toString().split("/").last),
                  );
                }
                return const SizedBox();
              }),
    );
  }
}
