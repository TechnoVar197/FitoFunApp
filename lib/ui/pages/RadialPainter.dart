import 'package:flutter/material.dart';
import 'dart:math' as math;

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = const Color(0xFF200087)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      -math.pi / 2,
      -relativeProgress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}