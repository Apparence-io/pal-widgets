// coverage:ignore-file
import 'package:flutter/material.dart';

import 'anchor_painter.dart';
import 'anchored_rect_painter.dart';
import 'animated_anchor.dart';

class _AnchoredRectHoleHelperFactory extends AnchorWidgetFactory {
  const _AnchoredRectHoleHelperFactory();

  @override
  Widget create({
    Offset? currentPos,
    Size? anchorSize,
    Color? bgColor,
    Function? onTap,
    Listenable? listenable,
  }) {
    return AnchoredRectHoleHelper(
      currentPos: currentPos,
      padding: 8,
      bgColor: bgColor,
      anchorSize: anchorSize,
      listenable: listenable!,
      onTap: onTap,
    );
  }
}

const _rect1Width = 16;
const _rect2Width = 32;

/// Helper explaining a widget
/// this creates a full background widget with a hole of the size of the aimed
/// widget.
class AnchoredRectHoleHelper extends BasicAnchoredHoleHelper {
  static const AnchorWidgetFactory anchorFactory =
      _AnchoredRectHoleHelperFactory();

  AnchoredRectHoleHelper({
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
  CustomPainter get customPainter => AnchoredRectPainter(
        currentPos: currentPos,
        anchorSize: anchorSize,
        padding: padding,
        bgColor: bgColor,
        rect1Width: stroke1Animation.value * _rect1Width,
        rect2Width: stroke2Animation.value * _rect2Width,
      );
}
