import 'package:flutter/material.dart';
import 'package:pal_widgets/services/element_finder.dart';

import 'anchored/anchor_model.dart';
import 'anchored/anchored_helper_widget.dart';
import 'services/overlay_helper.dart';

/// used to align the helper to the top, bottom, left or right of the anchor
enum HelperAlignment { top, bottom, left, right }

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
  final GlobalKey<NavigatorState>? navigatorKey;

  const HelperOrchestrator({
    Key? key, 
    required this.child, 
    this.navigatorKey,
  }) : super(key: key);

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

/// State for [HelperOrchestrator]
///
/// Can display an helper as overlay above a child using
/// the current [BuildContext] and [HelperOrchestrator.of]
class HelperOrchestratorState extends State<HelperOrchestrator> {
  final Map<String, Key> keys = {};
  final OverlayHelper _overlayHelper = OverlayHelper();
  ElementFinder? _elementFinder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(widget.navigatorKey != null) {
      _elementFinder = ElementFinder(navigatorKey: widget.navigatorKey);
    } else {
      _elementFinder = ElementFinder(buildContext: context);
    }
  }

  /// generate a [key] that will be registered within HelperOrchestrator
  /// this keyId is associated with the key and can be found again
  /// using [getAnchorKey]
  /// The key will be used to find the element position when requesting
  /// [showAnchoredHelper]
  Key generateKey(String key) {
    // final uniqueKey = GlobalKey(debugLabel: key);
    final uniqueKey = ValueKey(key);
    keys[key] = uniqueKey;
    return uniqueKey;
  }

  /// Returns the [Key] from the KeyId if found.
  /// this throws if not found.
  Key getAnchorKey(String keyId) {
    if (keys.containsKey(keyId)) {
      return keys[keyId]!;
    }
    throw 'Key not found';
  }

  /// This shows an [AnchoredHelper] above your page as overlay
  ///
  /// requires [anchorKeyId] that must have been generated within a widget using
  /// ```dart
  /// HelperOrchestrator.of(context).generateKey('myKeyId')
  /// ```
  Future showAnchoredHelper(String anchorKeyId, AnchoredHelper helper, {HelperAlignment? align,}) async {
    try {
      //final key = getAnchorKey(anchorKeyId) as ValueKey<String>;
      final anchor = await findAnchor(anchorKeyId, align: align);
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
    } catch (e) {
      debugPrint("show anchored helper failed: $e");
    }
  }

  /// Returns an [Anchor] wich contains position, size and rect of the widget
  /// containing the key.
  ///
  /// this requires an [anchorKeyId] to search within our keys
  Future<Anchor?> findAnchor(String anchorKeyId, {HelperAlignment? align,}) async {
    final element = _elementFinder! //
        .searchChildElementByKey(getAnchorKey(anchorKeyId));
    if (element == null || element.bounds == null) {
      debugPrint("anchor not found");
      return null;
    }
    final anchorSize = element.bounds!.size;
    final currentPos = element.offset!;
    if(align != null) {
      return Anchor(
        size: anchorSize,
        offset: currentPos,
        rect: _elementFinder!.getSpaceFromAlignment(align, element),
      );
    }
    return Anchor(
      size: anchorSize,
      offset: currentPos,
      rect: _elementFinder!.getLargestAvailableSpace(element),
    );
  }

  /// Hide the current overlayed helper
  /// this do nothing if there is no helper overlayed.
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
