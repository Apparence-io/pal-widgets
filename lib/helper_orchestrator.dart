import 'package:flutter/material.dart';
import 'package:pal_widgets/services/element_finder.dart';

import 'anchored/anchor_model.dart';
import 'anchored/anchored_helper_widget.dart';
import 'services/overlay_helper.dart';

class HelperOrchestrator extends InheritedWidget {
  final Map<String, Key> keys;
  final OverlayHelper _overlayHelper;
  final ElementFinder elementFinder;
  final WidgetBuilder builder;

  HelperOrchestrator({
    Key? key,
    required this.elementFinder,
    required this.builder,
  })  : _overlayHelper = OverlayHelper(),
        keys = {},
        super(
          key: key,
          child: Builder(builder: builder),
        );

  static HelperOrchestrator? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HelperOrchestrator>();

  Key generateKey(String key) {
    // final uniqueKey = UniqueKey();
    final uniqueKey = ValueKey(key);
    keys[key] = uniqueKey;
    return uniqueKey;
  }

  Key getAnchorKey(String keyId) {
    if (keys.containsKey(keyId)) {
      return keys[keyId]!;
    }
    throw 'Key not found';
  }

  Future showAnchoredHelper(
      BuildContext context, String anchorKeyId, AnchoredHelper helper) async {
    final anchor = await findAnchor(context, anchorKeyId);
    if (anchor == null) {
      debugPrint("anchor cannot be found. show anchored failed");
      return;
    }
    _overlayHelper.showHelper(
      context,
      (context) => AnchorHelperWrapper(
        anchor: anchor,
        child: helper,
      ),
    );
  }

  void hideHelper() {
    _overlayHelper.popHelper();
  }

  Future<Anchor?> findAnchor(BuildContext context, String anchorKeyId) async {
    final element =
        elementFinder.searchChildElementByKey(getAnchorKey(anchorKeyId));
    if (element == null || element.bounds == null) {
      debugPrint("anchor not found");
      return null;
    }
    final anchorSize = element.bounds!.size;
    final currentPos = element.offset!;
    final writeArea = elementFinder.getLargestAvailableSpace(element);
    return Anchor(
      size: anchorSize,
      offset: currentPos,
      rect: writeArea,
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

// mixin HelperOrchestratorStateMixin<T extends StatefulWidget> on State<T> {
//   void hideHelper() => HelperOrchestrator.of(context)!.hideHelper();

//   Future<void> showAnchoredHelper(String anchorKeyId, AnchoredHelper helper) =>
//       HelperOrchestrator.of(context)! //
//           .showAnchoredHelper(context, 'text1', helper);
// }
