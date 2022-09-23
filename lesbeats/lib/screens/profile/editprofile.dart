import 'dart:ui';

import 'package:flutter/material.dart';

editprofile(BuildContext context) {
  showDialog(
      context: context,
      builder: ((context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: const AlertDialog(
              title: Text("Edit profile"),
            ),
          )));
}
