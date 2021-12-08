// coverage:ignore-file
import 'package:flutter/material.dart';

import 'anchor_painter.dart';
import 'anchored_circle_painter.dart';
import 'animated_anchor.dart';

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
    return AnchoredCircleHoleHelper(
      currentPos: currentPos,
      padding: 8,
      bgColor: bgColor,
      anchorSize: anchorSize,
      listenable: listenable!,
      onTap: onTap,
    );
  }
}

const _circle1Width = 88;
const _circle2Width = 140;

/// Helper explaining a widget
/// this creates a full background widget with a hole of the size of the aimed
/// widget.
class AnchoredCircleHoleHelper extends BasicAnchoredHoleHelper {
  static const AnchorWidgetFactory anchorFactory = _AnchoredHoleHelperFactory();

  AnchoredCircleHoleHelper({
    Key? key,
    required Offset? currentPos,
    required double padding,
    required Color? bgColor,
    required Size? anchorSize,
    required Listenable listenable,
    Function? onTap,
  }) : super(
          key: key,
          listenable: listenable,
          currentPos: currentPos,
          padding: padding,
          bgColor: bgColor,
          anchorSize: anchorSize,
          onTap: onTap,
        );

  @override
  CustomPainter get customPainter => AnchoredCirclePainter(
        currentPos: currentPos,
        anchorSize: anchorSize,
        padding: padding,
        bgColor: bgColor,
        circle1Width: stroke1Animation.value * _circle1Width,
        circle2Width: stroke2Animation.value * _circle2Width,
      );
}
