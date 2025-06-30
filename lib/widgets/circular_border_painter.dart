import 'package:flutter/material.dart';
import 'dart:math' as math;


class CircularBorderPainter extends CustomPainter {
  final double progress;

  CircularBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Rect rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    canvas.drawArc(
      rect,
      -math.pi / 2, // Start at top
      2 * math.pi * progress, // Animate progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
