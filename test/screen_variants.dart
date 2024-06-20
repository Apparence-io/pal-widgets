import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

const iphone8Plus = ScreenSize('Iphone 8 Plus', 414, 736, 3);
const iphone11Max = ScreenSize('Iphone 11 Max', 414, 896, 3);
const samsungGalaxyS = ScreenSize('Android Samsung Galaxy S', 480, 800, 1);

final basicPhones = <ScreenSize>{iphone8Plus, iphone11Max, samsungGalaxyS};

/// this class defines a size configuration of a specific device
class ScreenSize {
  /// name this configuration
  final String name;

  /// size configuration and pixel density
  final double width, height, pixelDensity;

  const ScreenSize(this.name, this.width, this.height, this.pixelDensity);

  @override
  String toString() => name;
}

extension ScreenSizeManager on WidgetTester {
  Future<void> setScreenSize(ScreenSize screenSize) async {
    return _setScreenSize(
        width: screenSize.width,
        height: screenSize.height,
        pixelDensity: screenSize.pixelDensity);
  }

  Future<void> _setScreenSize(
      {double width = 540,
      double height = 960,
      double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = pixelDensity;
    // Old code
    // binding.window.physicalSizeTestValue = size;
    // binding.window.devicePixelRatioTestValue = pixelDensity;
  }
}
