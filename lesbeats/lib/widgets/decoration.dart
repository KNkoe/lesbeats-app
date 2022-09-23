import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lesbeats/widgets/theme.dart';

InputDecoration dialogInputdecoration = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = starCommandblue
    ..backgroundColor = Colors.white
    ..indicatorColor = background
    ..textColor = background
    ..maskColor = starCommandblue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;
}
