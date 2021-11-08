// coverage:ignore-file
import 'package:flutter/material.dart';

import 'anchor_painter.dart';
import 'anchored_circle_painter.dart';

class _AnchoredHoleHelperFactory extends AnchorWidgetFactory {
  const _AnchoredHoleHelperFactory();

  @override
  Widget create({
    Offset? currentPos,
    Size? anchorSize,
    Color? bgColor,
    Function? onTap,
    Listenable? listenable,
  }) {
    return AnchoredHoleHelper(
      currentPos: currentPos,
      padding: 8,
      bgColor: bgColor,
      anchorSize: anchorSize,
      listenable: listenable!,
    );
  }
}

/// Helper explaining a widget
/// this creates a full background widget with a hole of the size of the aimed
/// widget.
class AnchoredHoleHelper extends AnimatedWidget {
  final Offset? currentPos;
  final double padding;
  final Size? anchorSize;
  final Color? bgColor;
  final Function? onTap;

  final Animation<double> _stroke1Animation, _stroke2Animation;

  static const AnchorWidgetFactory anchorFactory = _AnchoredHoleHelperFactory();

  AnchoredHoleHelper({
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
          painter: AnchoredFullscreenPainter(
            currentPos: currentPos,
            anchorSize: anchorSize,
            padding: padding,
            bgColor: bgColor,
            circle1Width: _stroke1Animation.value * 88, // TODO params
            circle2Width: _stroke2Animation.value * 140, // TODO params
          ),
        ),
      ),
    );
  }
}
