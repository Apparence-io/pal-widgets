import 'package:flutter/material.dart';

extension AddSize on Size {
  withPadding(double padding) {
    return Size(width + padding, height + padding);
  }
}

class AnchoredRectPainter extends CustomPainter {
  final Offset? currentPos;

  final double padding;

  final Size? anchorSize;

  final Color? bgColor;

  double? radius;
  Offset? center;

  double rect1Width, rect2Width;

  AnchoredRectPainter({
    this.currentPos,
    this.anchorSize,
    this.padding = 0,
    this.bgColor,
    this.rect1Width = 32,
    this.rect2Width = 64,
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
    Paint rect1Painter = Paint()
      ..color = Colors.white.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = rect1Width
      ..isAntiAlias = true;
    Paint rect2Painter = Paint()
      ..color = Colors.white.withOpacity(.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = rect2Width
      ..isAntiAlias = true;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPainter);

    center = centerCalc;
    final rect = Rect.fromLTWH(
      currentPos!.dx,
      currentPos!.dy,
      anchorSize!.width,
      anchorSize!.height,
    );
    canvas.drawRect(rect, rect1Painter);
    canvas.drawRect(rect, rect2Painter);
    canvas.drawRect(currentPos! & anchorSize!, clearPainter);
    canvas.restore();
  }

  @pragma('vm:prefer-inline')
  Offset get centerCalc => currentPos!.translate(
        anchorSize!.width / 2,
        anchorSize!.height / 2,
      );

  @override
  bool shouldRepaint(AnchoredRectPainter oldDelegate) {
    return oldDelegate.currentPos != currentPos ||
        oldDelegate.rect1Width != rect1Width ||
        oldDelegate.rect2Width != rect2Width ||
        oldDelegate.bgColor != bgColor;
  }

  @override
  bool hitTest(Offset position) {
    if (currentPos == null) return false;
    return (position.dx >= currentPos!.dx &&
        position.dx <= (currentPos!.dx + anchorSize!.width) &&
        position.dy >= currentPos!.dy &&
        position.dy <= (currentPos!.dy + anchorSize!.height));
  }
}
