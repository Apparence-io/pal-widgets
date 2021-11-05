import 'package:flutter/material.dart';
import 'package:pal_widgets/services/element_finder.dart';

import 'anchored/anchor_model.dart';
import 'anchored/anchored_helper_widget.dart';
import 'services/overlay_helper.dart';

class _HelperOrchestratorScope extends InheritedWidget {
  final HelperOrchestratorState _helperOrchestratorState;

  const _HelperOrchestratorScope({
    Key? key,
    required Widget child,
    required HelperOrchestratorState helperOrchestratorState,
  })  : _helperOrchestratorState = helperOrchestratorState,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_HelperOrchestratorScope old) =>
      _helperOrchestratorState != old._helperOrchestratorState;
}

/// Manages Pal widgets to display an [Overlay] over your pages
/// this will allow you to register widgets and show [AnchoredHelper] and others
/// Pal onboarding widgets
class HelperOrchestrator extends StatefulWidget {
  final Widget child;

  const HelperOrchestrator({Key? key, required this.child}) : super(key: key);

  /// If there is no [HelperOrchestrator] in scope
  ///
  /// See also:
  ///
  ///  * [maybeOf], which is a similar function but will return null instead of
  ///    throwing if there is no [HelperOrchestrator] ancestor.
  static HelperOrchestratorState of(BuildContext context) {
    assert(debugCheckHasScaffoldMessenger(context));

    final _HelperOrchestratorScope scope =
        context.dependOnInheritedWidgetOfExactType<_HelperOrchestratorScope>()!;
    return scope._helperOrchestratorState;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context, if any.
  ///
  /// Will return null if a [HelperOrchestrator] is not found in the given context.
  ///
  /// See also:
  ///
  ///  * [of], which is a similar function, except that it will throw an
  ///    exception if a [HelperOrchestrator] is not found in the given context.
  static HelperOrchestratorState? maybeOf(BuildContext? context) {
    if (context == null) {
      return null;
    }
    final _HelperOrchestratorScope? scope =
        context.dependOnInheritedWidgetOfExactType<_HelperOrchestratorScope>();
    return scope?._helperOrchestratorState;
  }

  @override
  HelperOrchestratorState createState() => HelperOrchestratorState();
}

class HelperOrchestratorState extends State<HelperOrchestrator> {
  final Map<String, Key> keys = {};
  final OverlayHelper _overlayHelper = OverlayHelper();
  ElementFinder? _elementFinder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _elementFinder = ElementFinder(context);
  }

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

  Future showAnchoredHelper(String anchorKeyId, AnchoredHelper helper) async {
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

  Future<Anchor?> findAnchor(BuildContext context, String anchorKeyId) async {
    final element = _elementFinder! //
        .searchChildElementByKey(getAnchorKey(anchorKeyId));
    if (element == null || element.bounds == null) {
      debugPrint("anchor not found");
      return null;
    }
    final anchorSize = element.bounds!.size;
    final currentPos = element.offset!;
    final writeArea = _elementFinder!.getLargestAvailableSpace(element);
    return Anchor(
      size: anchorSize,
      offset: currentPos,
      rect: writeArea,
    );
  }

  void hideHelper() {
    _overlayHelper.popHelper();
  }

  @override
  Widget build(BuildContext context) {
    return _HelperOrchestratorScope(
      helperOrchestratorState: this,
      child: widget.child,
    );
  }
}

// class HelperOrchestrator extends InheritedWidget {
//   final Map<String, Key> keys;
//   final OverlayHelper _overlayHelper;
//   final ElementFinder elementFinder;
//   final WidgetBuilder builder;

//   HelperOrchestrator({
//     Key? key,
//     required this.elementFinder,
//     required this.builder,
//   })  : _overlayHelper = OverlayHelper(),
//         keys = {},
//         super(
//           key: key,
//           child: Builder(builder: builder),
//         );

//   static HelperOrchestrator? of(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType<HelperOrchestrator>();

//   Key generateKey(String key) {
//     // final uniqueKey = UniqueKey();
//     final uniqueKey = ValueKey(key);
//     keys[key] = uniqueKey;
//     return uniqueKey;
//   }

//   Key getAnchorKey(String keyId) {
//     if (keys.containsKey(keyId)) {
//       return keys[keyId]!;
//     }
//     throw 'Key not found';
//   }

//   Future showAnchoredHelper(
//       BuildContext context, String anchorKeyId, AnchoredHelper helper) async {
//     final anchor = await findAnchor(context, anchorKeyId);
//     if (anchor == null) {
//       debugPrint("anchor cannot be found. show anchored failed");
//       return;
//     }
//     _overlayHelper.showHelper(
//       context,
//       (context) => AnchorHelperWrapper(
//         anchor: anchor,
//         child: helper,
//       ),
//     );
//   }

//   void hideHelper() {
//     _overlayHelper.popHelper();
//   }

//   Future<Anchor?> findAnchor(BuildContext context, String anchorKeyId) async {
//     final element =
//         elementFinder.searchChildElementByKey(getAnchorKey(anchorKeyId));
//     if (element == null || element.bounds == null) {
//       debugPrint("anchor not found");
//       return null;
//     }
//     final anchorSize = element.bounds!.size;
//     final currentPos = element.offset!;
//     final writeArea = elementFinder.getLargestAvailableSpace(element);
//     return Anchor(
//       size: anchorSize,
//       offset: currentPos,
//       rect: writeArea,
//     );
//   }

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
// }

// mixin HelperOrchestratorStateMixin<T extends StatefulWidget> on State<T> {
//   void hideHelper() => HelperOrchestrator.of(context)!.hideHelper();

//   Future<void> showAnchoredHelper(String anchorKeyId, AnchoredHelper helper) =>
//       HelperOrchestrator.of(context)! //
//           .showAnchoredHelper(context, 'text1', helper);
// }
