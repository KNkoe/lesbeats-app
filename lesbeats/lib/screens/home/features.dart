import 'package:flutter/material.dart';

import '../../widgets/decoration.dart';

showFeatureNotAvail(BuildContext context) {
  showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: ((context) => AlertDialog(
            title: Column(
              children: [
                Text(
                  "This feature is not available yet. Please beware that only free beats are availbale.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Keep an eye out for updates and get ready to experience buying  and selling soon!",
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: cancelButtonStyle,
                  child: const Text("Close"))
            ],
          )));
}
