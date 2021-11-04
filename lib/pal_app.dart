import 'package:flutter/material.dart';

import 'helper_orchestrator.dart';
import 'services/element_finder.dart';

class PalApp extends StatelessWidget {
  final WidgetBuilder builder;

  const PalApp({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HelperOrchestrator(
      elementFinder: ElementFinder(context),
      builder: builder,
    );
  }
}
