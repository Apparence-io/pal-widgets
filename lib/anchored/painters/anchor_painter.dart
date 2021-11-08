import 'package:flutter/material.dart';

/// Used by [AnchoredWidget] to paint the background
abstract class AnchorWidgetFactory {
  const AnchorWidgetFactory();

  @factory
  Widget create({
    final Offset? currentPos,
    final Size? anchorSize,
    final Color? bgColor,
    final Function? onTap,
    final Listenable? listenable,
  });
}
