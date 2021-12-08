import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_widgets/pal_widgets.dart';

import 'widgets/anchored_circle_page_.dart';
import 'widgets/anchored_circle_no_buttons.dart';

void main() {
  group('circle anchor widget with buttons', () {
    testWidgets('click on button => shows an anchored widget overlay', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyAppWithCircleAnchored());
      expect(find.byType(AnchoredHelper), findsNothing);
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(AnchoredHelper), findsOneWidget);
    });

    testWidgets(
        'shows an anchored widget overlay => positiv button close helper', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyAppWithCircleAnchored());
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pump(const Duration(seconds: 2));
      // tap on positiv button
      final btn1 = find.byType(OutlinedButton).at(1).evaluate().first.widget
          as OutlinedButton;
      btn1.onPressed!();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(AnchoredHelper), findsNothing);
    });

    testWidgets(
        'shows an anchored widget overlay => negative button close helper', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyAppWithCircleAnchored());
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pump(const Duration(seconds: 2));
      // tap on positiv button
      final btn2 = find.byType(OutlinedButton).at(2).evaluate().first.widget
          as OutlinedButton;
      btn2.onPressed!();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(AnchoredHelper), findsNothing);
    });
  });

  group('Circle anchor widget - no buttons', () {
    testWidgets('click on button => shows an anchored widget overlay', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyAppAnchoredNoBtn());
      expect(find.byType(AnchoredHelper), findsNothing);
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(AnchoredHelper), findsOneWidget);
    });

    testWidgets(
        'shows an anchored widget overlay => tap on anchor area close helper', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyAppAnchoredNoBtn());
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pump(const Duration(seconds: 2));
      // tap on anchor area button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(AnchoredHelper), findsNothing);
    });

    testWidgets(
        '''tap on anchor area => helper is closed and counter is not incremented
         (still 0)''', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyAppAnchoredNoBtn());
      await tester.tap(find.byType(OutlinedButton).first);
      await tester.pump(const Duration(seconds: 2));
      // tap on anchor area button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(AnchoredHelper), findsNothing);
      expect(find.text('0'), findsOneWidget);
    });
  });
}
