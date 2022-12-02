import 'dart:ui';

import 'package:animations/animations.dart';
// ignore: depend_on_referenced_packages
import 'package:audio_session/audio_session.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lesbeats/screens/player/common.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:rxdart/rxdart.dart';

playOffline(BuildContext context, PlatformFile audio) {
  Scaffold.of(context).showBottomSheet(
    (context) => MiniPlayer(
      audio: audio,
    ),
  );
}

playOnline(BuildContext context, String url, Map<String, String> tags) {
  Scaffold.of(context).showBottomSheet(
      (context) => MiniPlayer(
            url: url,
            tags: tags,
          ),
      enableDrag: true);
}

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key, this.audio, this.url, this.tags})
      : super(key: key);
  final PlatformFile? audio;
  final String? url;
  final Map<String, String>? tags;

  @override
  MiniPlayerState createState() => MiniPlayerState();
}

class MiniPlayerState extends State<MiniPlayer> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  final _tagger = Audiotagger();

  bool _repeat = false;
  bool _isFavourite = false;

  String? _title;
  String? _artist;
  Uint8List? _artwork;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      debugPrint(e.toString());
    });
    // Try to load audio from a source and catch any errors.
    if (widget.url != null) {
      try {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.url!)));
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      _player.setFilePath(widget.audio!.path!);
    }

    final String filePath;

    final Tag? tag;
    final Uint8List? bytes;

    if (widget.audio != null) {
      filePath = widget.audio!.path!;
      tag = await _tagger.readTags(path: filePath);
      bytes = await _tagger.readArtwork(path: filePath);

      setState(() {
        _title = tag!.title;
        _artist = tag.artist;
        _artwork = bytes;
      });
    }

    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedBuilder: (context, fuction) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 115,
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.fromLTRB(14, 0, 10, 0),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: (widget.audio != null)
                                  ? (_artwork == null)
                                      ? Image.asset(
                                          "assets/images/cover.jpg",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.memory(
                                          _artwork!,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.network(
                                      widget.tags!["cover"]!,
                                      fit: BoxFit.cover,
                                    )),
                          SizedBox(
                            width: screenSize(context).width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    (widget.audio != null)
                                        ? (_title == null)
                                            ? widget.audio!.name
                                            : _title!.isEmpty
                                                ? widget.audio!.name
                                                : _title!
                                        : widget.tags!["title"]!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    (widget.audio != null)
                                        ? _artist == null
                                            ? ""
                                            : _artist!
                                        : widget.tags!["artist"]!,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          } else if (playing != true) {
                            return IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                size: 36,
                              ),
                              onPressed: _player.play,
                            );
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                              icon: const Icon(Icons.pause, size: 36),
                              onPressed: _player.pause,
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(
                                Icons.replay,
                                size: 36,
                              ),
                              onPressed: () => _player.seek(Duration.zero),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _player.seek,
                      );
                    },
                  ),
                ],
              ),
            ),
        openBuilder: (context, function) {
          return StatefulBuilder(
              builder: ((context, setState) => Stack(
                    children: [
                      (widget.audio != null)
                          ? (_artwork == null)
                              ? Image(
                                  image: const AssetImage(
                                      "assets/images/cover.jpg"),
                                  height: screenSize(context).height * 2,
                                  width: screenSize(context).width * 2,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  _artwork!,
                                  height: screenSize(context).height * 2,
                                  width: screenSize(context).width * 2,
                                  fit: BoxFit.cover,
                                )
                          : Image.network(
                              widget.tags!["cover"]!,
                              height: screenSize(context).height * 2,
                              width: screenSize(context).width * 2,
                              fit: BoxFit.cover,
                            ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  "Now Playing",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Colors.white10,
                                      shape: BoxShape.circle),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        color: Colors.white12,
                                        shape: BoxShape.circle),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            color: Colors.white24,
                                            shape: BoxShape.circle),
                                        child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            height:
                                                screenSize(context).width * 0.7,
                                            width:
                                                screenSize(context).width * 0.7,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: (widget.audio != null)
                                                ? (_artwork == null)
                                                    ? Image.asset(
                                                        "assets/images/cover.jpg",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        _artwork!,
                                                        fit: BoxFit.cover,
                                                      )
                                                : Image.network(
                                                    widget.tags!["cover"]!,
                                                    fit: BoxFit.cover,
                                                  ))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        (widget.audio != null)
                                            ? (_title == null)
                                                ? widget.audio!.name
                                                : _title!.isEmpty
                                                    ? widget.audio!.name
                                                    : _title!
                                            : widget.tags!["title"]!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        (widget.audio != null)
                                            ? _artist == null
                                                ? ""
                                                : _artist!
                                            : widget.tags!["artist"]!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white54),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ControlButtons(_player),
                                const SizedBox(
                                  height: 20,
                                ),
                                StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return SeekBar(
                                      duration: positionData?.duration ??
                                          Duration.zero,
                                      position: positionData?.position ??
                                          Duration.zero,
                                      bufferedPosition:
                                          positionData?.bufferedPosition ??
                                              Duration.zero,
                                      onChangeEnd: _player.seek,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.elliptical(100, 20),
                                      topLeft: Radius.elliptical(100, 20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _repeat = !_repeat;
                                        });

                                        if (_repeat) {
                                          _player.setLoopMode(LoopMode.one);
                                        }
                                      },
                                      icon: Icon(
                                        _repeat
                                            ? Icons.repeat_one
                                            : Icons.repeat_rounded,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isFavourite = !_isFavourite;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        color: _isFavourite
                                            ? Colors.red
                                            : Colors.white,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )));
        });
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(
            Icons.volume_up,
            color: Colors.white,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white), shape: BoxShape.circle),
          child: StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 30,
                  height: 30,
                  child: const CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    icon: const Icon(Icons.pause, color: Colors.white),
                    onPressed: player.pause);
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay, color: Colors.white),
                  onPressed: () => player.seek(Duration.zero),
                );
              }
            },
          ),
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
