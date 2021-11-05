import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_widgets/pal_widgets.dart';

import 'anchored_page.dart';

void main() {
  testWidgets('click on button => shows an anchored widget overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyAppWithAnchored());
    expect(find.byType(AnchoredHelper), findsNothing);
    await tester.tap(find.byType(OutlinedButton).first);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(AnchoredHelper), findsOneWidget);
  });

  testWidgets('shows an anchored widget overlay => positiv button close helper',
      (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyAppWithAnchored());
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
    await tester.pumpWidget(const MyAppWithAnchored());
    await tester.tap(find.byType(OutlinedButton).first);
    await tester.pump(const Duration(seconds: 2));
    // tap on positiv button
    final btn2 = find.byType(OutlinedButton).at(2).evaluate().first.widget
        as OutlinedButton;
    btn2.onPressed!();
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(AnchoredHelper), findsNothing);
  });
}
