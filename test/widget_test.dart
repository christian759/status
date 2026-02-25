// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:status/main.dart';

void main() {
  testWidgets('StatusVault home renders basic navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const StatusVaultApp());
    await tester.pumpAndSettle();

    expect(find.text('Status Feed'), findsOneWidget);
    expect(find.byIcon(Icons.grid_view), findsOneWidget);
  });
}
