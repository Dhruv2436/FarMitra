import 'package:flutter/material.dart';
import 'dart:math';

class PeacockLoader extends StatefulWidget {
  const PeacockLoader({super.key});

  @override
  State<PeacockLoader> createState() => _PeacockLoaderState();
}

class _PeacockLoaderState extends State<PeacockLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<Color> _colors = [
    Colors.blue.shade700,
    Colors.green.shade500,
    Colors.amber.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _PeacockPainter(
              animationValue: _controller.value,
              colors: _colors,
            ),
          );
        },
      ),
    );
  }
}

class _PeacockPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  _PeacockPainter({required this.animationValue, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < colors.length; i++) {
      final angle = (2 * pi / colors.length) * i + (2 * pi * animationValue);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      paint.color = colors[i];
      canvas.drawCircle(Offset(x, y), 12 - i * 3.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}