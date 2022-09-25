// ignore_for_file: public_member_api_docs, sort_constructors_first
class Interaction {
  final int id;
  final String userid;
  final int songid;
  final bool liked;
  final int playCount;
  Interaction({
    required this.id,
    required this.userid,
    required this.songid,
    this.liked = false,
    this.playCount = 0,
  });
}
