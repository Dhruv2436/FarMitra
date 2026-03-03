import 'package:flutter/material.dart';
import 'dart:math';

class SunCurve extends StatelessWidget {
  const SunCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: CustomPaint(
        painter: SunPainter(),
      ),
    );
  }
}

class SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height - 50 * sin(i * pi / size.width),
      );
    }

    canvas.drawPath(path, paint);

    canvas.drawCircle(
        Offset(size.width / 2, size.height - 50),
        12,
        Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}