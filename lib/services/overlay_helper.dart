import 'package:flutter/material.dart';

class OverlayHelper {
  OverlayEntry? overlayEntry;

  OverlayHelper();

  showHelper(BuildContext context, WidgetBuilder widgetBuilder) {
    popHelper();
    overlayEntry = OverlayEntry(
      opaque: false,
      builder: widgetBuilder,
    );
    final overlay = Overlay.of(context);
    if (overlay != null) {
      overlay.insert(overlayEntry!);
    }
  }

  bool popHelper() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      return true;
    }
    return false;
  }
}
