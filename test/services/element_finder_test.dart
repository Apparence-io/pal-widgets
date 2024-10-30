import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_widgets/services/element_finder.dart';

void main() {
  group('Element finder with String key', () {
    Widget page = Scaffold(
      body: Column(
        children: [
          const Text("Test Text", key: ValueKey("text1")),
          const Text("Test Text 2", key: ValueKey("text2")),
          const Text("Test Text 3", key: ValueKey("text3")),
          // ignore: sized_box_for_whitespace
          Container(key: const ValueKey("container"), height: 50, width: 150)
        ],
      ),
    );

    testWidgets('''
    search a widget by key as String and find location + size. 
    this only work if this is a valueKey
    ''', (
      WidgetTester tester,
    ) async {
      BuildContext? _context;
      var app = MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(home: Builder(
            builder: (context) {
              _context = context;
              return page;
            },
          )));
      await tester.pumpWidget(app);
      ElementFinder finder = ElementFinder(buildContext: _context);
      var result = finder.searchChildElement("container")!;
      expect(result, isNotNull);
      expect(result.bounds!.size, equals(const Size(150, 50)));
    });

    testWidgets('scan widgets finds all with their rect',
        (WidgetTester tester) async {
      BuildContext? _context;
      var app = MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(home: Builder(
            builder: (context) {
              _context = context;
              return page;
            },
          )));
      await tester.pumpWidget(app);
      ElementFinder finder = ElementFinder(buildContext: _context);
      var elements = finder.scan();
      expect(elements, isNotNull);
      expect(elements.length, equals(6));
      var keys = elements.keys.toList();
      expect(keys[1], contains("text1"));
      expect(keys[2], contains("text2"));
      // expect(elements[keys.last].bounds.size, equals(Size(150, 50)));
    });
  });

  group('Element finder with key', () {
    final containerKey = UniqueKey();

    Widget page = Scaffold(
      body: Column(
        children: [
          const Text("Test Text", key: ValueKey("text1")),
          const Text("Test Text 2", key: ValueKey("text2")),
          const Text("Test Text 3", key: ValueKey("text3")),
          // ignore: sized_box_for_whitespace
          Container(key: containerKey, height: 50, width: 150)
        ],
      ),
    );

    testWidgets('search a widget by key and find location + size', (
      WidgetTester tester,
    ) async {
      BuildContext? _context;
      var app = MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(home: Builder(
            builder: (context) {
              _context = context;
              return page;
            },
          )));
      await tester.pumpWidget(app);
      ElementFinder finder = ElementFinder(buildContext: _context);
      var result =
          finder.searchChildElementByKey(containerKey, isInModal: false)!;
      expect(result, isNotNull);
      expect(result.bounds!.size, equals(const Size(150, 50)));
    });
  });
}
