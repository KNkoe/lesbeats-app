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
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lesbeats/services/player/common.dart';
import 'package:lesbeats/screens/profile/profile.dart';
import 'package:lesbeats/services/stream/report.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import '../stream/like.dart';

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

  String? _title;
  String? _artist;
  Uint8List? _artwork;

  @override
  void initState() {
    super.initState();
    _init();
    checkIfLiked(widget.tags!["id"]!);
  }

  bool liked = false;

  checkIfLiked(String trackId) async {
    await db
        .collection("tracks")
        .doc(trackId)
        .collection("likes")
        .doc(
          auth.currentUser!.uid,
        )
        .get()
        .then((doc) {
      liked = doc.exists;
    });
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
        await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.url!),
            tag: MediaItem(
                id: widget.tags!["id"]!,
                title: widget.tags!["title"]!,
                artist: widget.tags!["artist"]!,
                artUri: Uri.parse(widget.tags!["cover"]!))));
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
        closedColor: Colors.transparent,
        closedBuilder: (context, fuction) => Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, -4),
                        blurRadius: 5,
                        spreadRadius: 2,
                        color: Colors.black12)
                  ]),
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
                                  child: (widget.audio != null)
                                      ? Text(
                                          _artist == null ? "" : _artist!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )
                                      : OpenContainer(
                                          closedElevation: 0,
                                          closedColor: Colors.transparent,
                                          closedBuilder: ((context, action) =>
                                              Text(
                                                widget.tags!["artist"]!,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              )),
                                          openBuilder: (context, action) =>
                                              MyProfilePage(
                                                  widget.tags!["artistId"]!),
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
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          } else if (playing != true) {
                            return IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                size: 36,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: _player.play,
                            );
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                              icon: Icon(
                                Icons.pause,
                                size: 36,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: _player.pause,
                            );
                          } else {
                            return IconButton(
                              icon: Icon(
                                Icons.replay,
                                size: 30,
                                color: Theme.of(context).primaryColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Transform.rotate(
                                  angle: -1.5708,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white,
                                      )),
                                ),
                                Text("Now Playing",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: Colors.white)),
                                PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    itemBuilder: ((context) => [
                                          if (widget.tags!["artistId"]! !=
                                              auth.currentUser!.uid)
                                            PopupMenuItem(
                                                onTap: () {
                                                  Future.delayed(Duration.zero,
                                                      () {
                                                    report(widget.tags!["id"]!,
                                                        "Beat");
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.report,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text("Report"),
                                                  ],
                                                )),
                                        ]))
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
                                      child: (widget.audio != null)
                                          ? Text(
                                              _artist == null ? "" : _artist!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            )
                                          : OpenContainer(
                                              closedElevation: 0,
                                              closedColor: Colors.transparent,
                                              closedBuilder:
                                                  ((context, action) => Text(
                                                        widget.tags!["artist"]!,
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      )),
                                              openBuilder: (context, action) =>
                                                  MyProfilePage(widget
                                                      .tags!["artistId"]!),
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
                            StreamBuilder<PlayerState>(
                                stream: _player.playerStateStream,
                                builder: (context, snapshot) {
                                  final playerState = snapshot.data;
                                  final processingState =
                                      playerState?.processingState;

                                  final playing = playerState?.playing;
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        image: DecorationImage(
                                            opacity: 0.2,
                                            fit: BoxFit.cover,
                                            image: (playing == true &&
                                                    processingState !=
                                                        ProcessingState
                                                            .completed)
                                                ? const AssetImage(
                                                    "assets/images/bars.gif")
                                                : const AssetImage(
                                                    "assets/images/bars.jpg")),
                                        borderRadius: const BorderRadius.only(
                                            topRight:
                                                Radius.elliptical(100, 20),
                                            topLeft:
                                                Radius.elliptical(100, 20))),
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
                                                _player
                                                    .setLoopMode(LoopMode.one);
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
                                                if (!liked) {
                                                  likeTrack(
                                                      widget.tags!["id"]!);
                                                } else {
                                                  unlikeTrack(
                                                      widget.tags!["id"]!);
                                                }

                                                setState(() {
                                                  checkIfLiked(
                                                      widget.tags!["id"]!);
                                                });
                                              });
                                            },
                                            icon: Icon(
                                              Icons.favorite_rounded,
                                              color: liked
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white,
                                            ))
                                      ],
                                    ),
                                  );
                                })
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
