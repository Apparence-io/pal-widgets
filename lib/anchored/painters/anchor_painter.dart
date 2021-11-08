import 'package:flutter/material.dart';

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
