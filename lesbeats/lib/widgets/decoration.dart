import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

InputDecoration dialogInputdecoration = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xff2a9d8f)
    ..backgroundColor = const Color(0xff2a9d8f)
    ..indicatorColor = const Color(0xff2a9d8f)
    ..textColor = Colors.white
    ..maskColor = const Color(0xff2a9d8f).withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = true;
}
