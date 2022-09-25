// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lesbeats/models/track.dart';

class Genre {
  final String genre;
  final String coverUrl;
  final List<Track> tracks;
  Genre({
    required this.genre,
    required this.coverUrl,
    this.tracks = const [],
  });
}
