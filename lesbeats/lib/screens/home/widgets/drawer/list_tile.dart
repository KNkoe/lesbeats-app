import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/theme.dart';

Widget drawerListTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required Function()? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
    child: ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      leading: Icon(
        icon,
        color: background,
      ),
      selectedColor: Colors.white,
      selectedTileColor: background,
      onTap: onTap,
      title: Text(
        title,
      ),
    ),
  );
}
