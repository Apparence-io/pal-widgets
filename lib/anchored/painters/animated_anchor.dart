// coverage:ignore-file
import 'package:flutter/material.dart';

/// Helper explaining a widget
/// this creates a full background widget with a hole of the size of the aimed
/// widget.
abstract class BasicAnchoredHoleHelper extends AnimatedWidget {
  final Offset? currentPos;
  final double padding;
  final Size? anchorSize;
  final Color? bgColor;
  final Function? onTap;

  final Animation<double> _stroke1Animation, _stroke2Animation;

  CustomPainter get customPainter;

  Animation<double> get stroke1Animation => _stroke1Animation;

  Animation<double> get stroke2Animation => _stroke2Animation;

  BasicAnchoredHoleHelper({
    Key? key,
    required this.currentPos,
    required this.padding,
    required this.bgColor,
    required this.anchorSize,
    required Listenable listenable,
    this.onTap,
  })  : _stroke1Animation = CurvedAnimation(
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
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: SizedBox(
        child: CustomPaint(
          painter: customPainter,
        ),
      ),
    );
  }
}
