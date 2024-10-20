import 'package:flutter/material.dart';
import 'dart:math' as math;

class RadialProgress extends StatelessWidget {
  final double width;
  final double height;
  final double progress;

  const RadialProgress({
    required this.width,
    required this.height,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadialPainter(progress: progress),
      child: SizedBox(
        width: width,
        height: height,
      ),
    );
  }
}

class RadialPainter extends CustomPainter {
  final double progress;

  RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      angle,
      false,
      completeArc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
