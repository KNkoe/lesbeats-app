class Interaction {
  final int id;
  final String userid;
  final int songid;
  final bool liked;
  final bool sold;
  final int playCount;
  Interaction({
    required this.id,
    required this.userid,
    required this.songid,
    this.liked = false,
    this.sold = false,
    this.playCount = 0,
  });
}
