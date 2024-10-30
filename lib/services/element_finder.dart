import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:pal_widgets/helper_orchestrator.dart';

const minWritableSpace = 100;

/// This class helps you find element within your app
/// use [searchChildElement] with a String containing key value
/// result is available in [result] and returns an [Element]
class ElementFinder {
  // Prefer use the navigatorContext to get full context tree
  final BuildContext? buildContext;
  final GlobalKey<NavigatorState>? navigatorKey;

  ElementFinder({this.buildContext, this.navigatorKey});

  BuildContext get context {
    if (buildContext != null) {
      return buildContext!;
    }
    return navigatorKey!.currentContext!;
  }

  Size get screenSize => MediaQuery.of(context).size;

  // this method scan all child recursively to get all widget bounds we could select for an helper
  Map<String, ElementModel> scan({Key? omitChildsOf, bool debugMode = false}) {
    Map<String, ElementModel> results = <String, ElementModel>{};
    context.visitChildElements((element) => _scanChildElement(
        context.findRenderObject(), element, results,
        omitChildsOf: omitChildsOf, debugMode: debugMode));
    return results;
  }

  // List all pages from this context
  List<PageElement> scanPages() {
    var pages = [];
    context.visitChildElements((element) =>
        _scanPageChildElement(element, pages as List<PageElement>));
    return pages as List<PageElement>;
  }

  // this method scan all child recursively to find a widget having a key == searchedKey
  ElementModel? searchChildElement(String? key) {
    ElementModel? result;
    context.visitChildElements((element) =>
        result = _searchChildElement(context.findRenderObject(), element, key));
    if (result == null) {
      return ElementModel.empty();
    }
    return result;
  }

  ElementModel? searchChildElementByKey(
    Key key, {
    required bool isInModal,
  }) {
    ElementModel? result;
    context.visitChildElements((element) => result = _searchChildElementByKey(
          context.findRenderObject(),
          element,
          key,
          isInModal: isInModal,
        ));
    if (result == null) {
      return ElementModel.empty();
    }
    return result;
  }

  Rect getSpaceFromAlignment(HelperAlignment align, ElementModel elementModel) {
    var parentObject = context.findRenderObject()!;
    var element = elementModel.element!;
    // var translation = element.renderObject!.getTransformTo(parentObject).getTranslation();
    var objectX = elementModel.offset!.dx;
    var objectEndX = objectX + element.size!.width;
    var objectY = elementModel.offset!.dy;
    var objectEndY = objectY + element.size!.height;
    var layerRect = parentObject.paintBounds;
    switch (align) {
      case HelperAlignment.top:
        return Rect.fromLTWH(0, 0, layerRect.width, objectY);
      case HelperAlignment.bottom:
        return Rect.fromLTWH(0, objectEndY, layerRect.width, layerRect.height);
      case HelperAlignment.left:
        return Rect.fromLTWH(0, 0, objectX, layerRect.height);
      case HelperAlignment.right:
        return Rect.fromLTWH(
            objectEndX, 0, layerRect.width - objectEndX, layerRect.height);
    }
  }

  /// This functions search for the maximum rect available space
  /// We use it for example to find the most available space to write a text in our anchored helper
  Rect getLargestAvailableSpace(ElementModel elementModel) {
    var parentObject = context.findRenderObject()!;
    var element = elementModel.element!;
    var translation =
        element.renderObject!.getTransformTo(parentObject).getTranslation();
    var objectX = translation.x;
    var objectEndX = objectX + element.size!.width;
    var objectY = translation.y;
    var objectEndY = objectY + element.size!.height;
    var layerRect = parentObject.paintBounds;

    Rect availableHSpace;
    Rect availableWSpace;
    if (objectY > layerRect.height - objectEndY) {
      availableHSpace = Rect.fromLTWH(0, 0, layerRect.width, objectY);
    } else {
      availableHSpace = Rect.fromLTWH(
          0, objectEndY, layerRect.width, layerRect.height - objectEndY);
    }
    if (objectX > layerRect.width - objectEndX) {
      availableWSpace = Rect.fromLTWH(0, 0, objectX, layerRect.height);
    } else {
      availableWSpace = Rect.fromLTWH(
          objectEndX, 0, layerRect.width - objectEndX, layerRect.height);
    }
    // check area to use the largest
    var availableHSpaceArea =
        availableHSpace.size.width * availableHSpace.size.height;
    var availableWSpaceArea =
        availableWSpace.size.width * availableWSpace.size.height;
    if (availableWSpaceArea > availableHSpaceArea &&
        availableWSpace.width > minWritableSpace) {
      return availableWSpace;
    }
    return availableHSpace;
  }

  // -----------------------------------------------------------
  // private
  // -----------------------------------------------------------

  // ERROR
  ElementModel? _searchChildElement(
      RenderObject? parentObject, Element element, String? key,
      {int n = 0}) {
    if (element.widget.key != null &&
        element.widget.key.toString().contains(key!)) {
      try {
        // if render element has bounds lets take it
        var res = _createElementModel(parentObject, element, false);
        return res;
      } catch (_) {}
    }
    ElementModel? result;
    element.visitChildElements((visitor) {
      var res = _searchChildElement(parentObject, visitor, key, n: n + 1);
      if (res != null) result = res;
    });
    return result;
  }

  ElementModel? _searchChildElementByKey(
    RenderObject? parentObject,
    Element element,
    Key key, {
    int n = 0,
    required bool isInModal,
  }) {
    if (element.widget.key != null && element.widget.key == key) {
      try {
        // if render element has bounds lets take it
        return _createElementModel(parentObject, element, isInModal);
      } catch (_) {}
    }
    ElementModel? result;
    element.visitChildElements((visitor) {
      var res = _searchChildElementByKey(
        parentObject,
        visitor,
        key,
        n: n + 1,
        isInModal: isInModal,
      );
      if (res != null) result = res;
    });
    return result;
  }

  // omits elements with key starting with anything other than [<
  // flutter makes key with "[<_myKey_>]" for our keys
  // scan all elements in the current page tree and add their bounds to the results map
  _scanChildElement(RenderObject? parentObject, Element element,
      Map<String, ElementModel> results,
      {int n = 0, Key? omitChildsOf, bool debugMode = true}) {
    if (debugMode) {
      var nbChilds = element.debugDescribeChildren().length;
      var pre = StringBuffer();
      for (int i = 0; i < n; i++) {
        pre.write(" ");
      }
      debugPrint("$pre ${element.widget.runtimeType}  $n => $nbChilds ");
    }
    if (element.widget.key != null &&
        omitChildsOf != null &&
        element.widget.key.toString() == omitChildsOf.toString()) {
      return;
    }
    if (element.widget.key != null &&
        element.widget.key.toString().startsWith("[<") &&
        !results.containsKey(element.widget.key.toString())) {
      if (debugMode) {
        debugPrint("  added ${element.widget.key.toString()} : $n");
      }
      try {
        var model = _createElementModel(parentObject, element, false);
        if (results.values.firstWhereOrNull((element) =>
                element.bounds == model.bounds &&
                element.offset == model.offset) ==
            null) {
          results.putIfAbsent(element.widget.key.toString(), () => model);
        }
      } catch (e) {
        debugPrint("  error while getting element bounds:");
        debugPrint("$e");
      }
    }
    element.visitChildElements((visitor) => _scanChildElement(
        parentObject, visitor, results,
        n: n + 1, omitChildsOf: omitChildsOf, debugMode: debugMode));
  }

  // search first entries that contains our pages
  _scanPageChildElement(Element element, List<PageElement> pages) {
    if (element.runtimeType.toString() == "_Theatre") {
      element.visitChildElements((visitor) => pages.add(PageElement(element)));
    } else {
      element.visitChildElements(
          (visitor) => _scanPageChildElement(element, pages));
    }
  }

  ElementModel _createElementModel(
    RenderObject? parentObject,
    Element element,
    bool isInModal,
  ) {
    try {
      final mScreenSize = screenSize;
      var renderObject = element.findRenderObject()!;

      var bounds = renderObject.paintBounds;
      var translation = renderObject //
          .getTransformTo(parentObject)
          .getTranslation();
      // final parentBounds = parentObject!.paintBounds;
      if (isInModal) {
        final parentRenderObject = renderObject.parent!;
        final parentBounds = parentRenderObject.paintBounds;
        if (parentBounds.height < mScreenSize.height) {
          translation.y +=
              mScreenSize.height - parentBounds.height - bounds.height / 2;
        }
      }
      var offset = Offset(translation.x, translation.y);

      return ElementModel(
        element.widget.key.toString(),
        bounds,
        offset,
        element.widget.runtimeType,
        element: element,
      );
    } catch (e, s) {
      debugPrint("Error while creating element model: $e $s");
      rethrow;
    }
  }
}

class PageElement {
  Element element;

  PageElement(this.element);
}

class ElementModel {
  String? key;

  Rect? bounds;

  Offset? offset;

  Element? element;

  @override
  Type runtimeType;

  ElementModel(
    this.key,
    this.bounds,
    this.offset,
    this.runtimeType, {
    this.element,
  });

  factory ElementModel.empty() => ElementModel(null, null, null, ElementModel);
}
