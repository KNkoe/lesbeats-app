// ignore_for_file: public_member_api_docs, sort_constructors_first
class Track {
  final String id;
  final String albumId;
  final String artistId;
  final String title;
  final Duration duration;
  final int trackNO;
  final String path;
  final DateTime uploadedAt;
  Track({
    required this.id,
    this.albumId = "",
    required this.artistId,
    required this.title,
    required this.duration,
    this.trackNO = 0,
    required this.path,
    required this.uploadedAt,
  });
}
