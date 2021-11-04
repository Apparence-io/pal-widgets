import 'dart:math';

import 'package:flutter/material.dart';

class AnchoredFullscreenPainter extends CustomPainter {
  final Offset? currentPos;

  final double padding;

  final Size? anchorSize;

  final double area = 24.0 * 24.0;

  final Color? bgColor;

  double circle1Width, circle2Width;

  AnchoredFullscreenPainter({
    this.currentPos,
    this.anchorSize,
    this.padding = 0,
    this.bgColor,
    this.circle1Width = 64,
    this.circle2Width = 100,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint clearPainter = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;
    Paint bgPainter = Paint()
      ..color = bgColor!
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    Paint circle1Painter = Paint()
      ..color = Colors.white.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circle1Width
      ..isAntiAlias = true;
    Paint circle2Painter = Paint()
      ..color = Colors.white.withOpacity(.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circle2Width
      ..isAntiAlias = true;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPainter);
    // canvas.drawCircle(currentPos, radius, clearPainter);
    // canvas.drawRect(currentPos & anchorSize, clearPainter);
    var radius =
        sqrt(pow(anchorSize!.width, 2) + pow(anchorSize!.height, 2)) / 2;
    var center =
        currentPos!.translate(anchorSize!.width / 2, anchorSize!.height / 2);
    canvas.drawCircle(center, radius + padding, circle1Painter);
    canvas.drawCircle(center, radius + padding, circle2Painter);
    canvas.drawCircle(center, radius + padding, clearPainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(AnchoredFullscreenPainter oldDelegate) {
    return oldDelegate.currentPos != currentPos ||
        oldDelegate.circle1Width != circle1Width ||
        oldDelegate.circle2Width != circle2Width ||
        oldDelegate.bgColor != bgColor;
  }

  @override
  bool hitTest(Offset position) {
    if (currentPos == null) return false;
    var distance = (position - currentPos!).distanceSquared;
    if (distance <= area) {
      return true;
    }
    return false;
  }
}
