class Track {
  final String id;
  final String albumId;
  final String artistId;
  final String title;
  final Duration duration;
  final int trackNO;
  final String path;
  final DateTime uploadedAt;
  double price;
  Track({
    required this.id,
    this.albumId = "",
    required this.artistId,
    required this.title,
    required this.duration,
    this.trackNO = 0,
    this.price = 0,
    required this.path,
    required this.uploadedAt,
  });
}
