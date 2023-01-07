import 'package:url_launcher/url_launcher.dart';

report(String id, String subject) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'lesbeats0@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Report $subject $id (DO NOT EDIT SUBJECT)',
    }),
  );

  Future<void> launchEmail() async {
    if (!await launchUrl(emailLaunchUri)) {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  launchEmail();
}
