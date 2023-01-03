import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

InputDecoration dialogInputdecoration = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

ButtonStyle confirmButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xff2a9d8f),
  fixedSize: const Size(100, 40),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);

ButtonStyle cancelButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: const Color(0xff2a9d8f),
  fixedSize: const Size(100, 40),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);

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

Widget online(BuildContext context) => Container(
      margin: const EdgeInsets.all(10),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          border:
              Border.all(color: Theme.of(context).backgroundColor, width: 2),
          shape: BoxShape.circle,
          color: Colors.green),
    );
