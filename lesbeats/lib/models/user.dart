// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyUser {
  final String id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final bool isadmin;
  final bool isonline;
  MyUser({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.isadmin = false,
    this.isonline = false,
  });
}
