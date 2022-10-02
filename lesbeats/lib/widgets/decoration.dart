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

class DotIndicator extends Decoration {
  const DotIndicator({
    this.color = Colors.white,
    this.radius = 4.0,
  });
  final Color color;
  final double radius;
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(
      color: color,
      radius: radius,
      onChange: onChanged,
    );
  }
}

class _DotPainter extends BoxPainter {
  _DotPainter({
    required this.color,
    required this.radius,
    VoidCallback? onChange,
  })  : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        super(onChange);
  final Paint _paint;
  final Color color;
  final double radius;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    canvas.drawCircle(
      Offset(rect.bottomCenter.dx, rect.bottomCenter.dy - radius),
      radius,
      _paint,
    );
  }
}
