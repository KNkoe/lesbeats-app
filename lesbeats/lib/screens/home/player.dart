import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lesbeats/widgets/theme.dart';

showPlayer(BuildContext context, PlatformFile audio) {
  Scaffold.of(context).showBottomSheet((context) => MiniPlayer(
        audio: audio,
      ));
}

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key, required this.audio}) : super(key: key);

  final PlatformFile audio;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with TickerProviderStateMixin {
  late AnimationController _animationIconController1;
  final player = AudioPlayer();
  String? audioname;
  String? artistname;
  double? duration;
  double slider = 0;

  @override
  void initState() {
    super.initState();
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
      reverseDuration: const Duration(milliseconds: 750),
    );
    audioname = widget.audio.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 50,
            color: Colors.white10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  audioname!,
                  style: TextStyle(color: Colors.white60),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                      color: Colors.white60,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    color: Colors.white,
                    progress: _animationIconController1,
                  ),
                ),
                const SizedBox(width: 30),
                Row(
                  children: [
                    Text(
                      "02:05",
                      style: TextStyle(color: Colors.white60),
                    ),
                    Slider(value: 0.5, onChanged: (value) {}),
                    Text(
                      "02:30",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
