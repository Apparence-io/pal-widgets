import 'package:flutter/material.dart';

import 'anchored_circle_painter.dart';

class AnimatedAnchoredFullscreenCircle extends AnimatedWidget {
  final Offset? currentPos;
  final double padding;
  final Size? anchorSize;
  final Color? bgColor;

  final Animation<double> _stroke1Animation, _stroke2Animation;

  AnimatedAnchoredFullscreenCircle(
      {Key? key,
      required this.currentPos,
      required this.padding,
      required this.bgColor,
      required this.anchorSize,
      required Listenable listenable})
      : _stroke1Animation = CurvedAnimation(
          parent: listenable as Animation<double>,
          curve: Curves.ease,
        ),
        _stroke2Animation = CurvedAnimation(
          parent: listenable,
          curve: const Interval(0, .8, curve: Curves.ease),
        ),
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CustomPaint(
            painter: AnchoredFullscreenPainter(
      currentPos: currentPos,
      anchorSize: anchorSize,
      padding: padding,
      bgColor: bgColor,
      circle1Width: _stroke1Animation.value * 88, // TODO params
      circle2Width: _stroke2Animation.value * 140, // TODO params
    )));
  }
}
