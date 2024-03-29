// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:minimal/main.dart';
import 'package:minimal/app.dart';
import 'package:minimal/initialize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  await App.core.ensureInitialized();

  // testWidgets('Verify Platform version', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const Minimal());

  //   // Verify that platform version is retrieved.
  //   expect(
  //     find.byWidgetPredicate(
  //       (Widget widget) => widget is Text && widget.data!.startsWith('Running on:'),
  //     ),
  //     findsOneWidget,
  //   );
  // });
  group('MyWidgets', () {
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const Minimal());

      // Verify that our counter starts at 0.
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should display a string of text', (WidgetTester tester) async {
      // Define a Widget
      const myWidget = MaterialApp(
        home: Scaffold(
          body: Text('Hello'),
        ),
      );

      // Build myWidget and trigger a frame.
      await tester.pumpWidget(myWidget);

      // Verify myWidget shows some text
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
