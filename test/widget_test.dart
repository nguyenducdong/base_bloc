import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:base_bloc/main.dart';

void main() {
  testWidgets('Financial Guide App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinancialGuideApp());

    // Verify that the app title is displayed
    expect(find.text('Cẩm Nang tài chính'), findsOneOrMoreWidgets);

    // Verify that the search field is present
    expect(find.byType(TextField), findsOneOrMoreWidgets);

    // Verify that both tabs are present
    expect(find.text('Mẹo tài chính'), findsOneOrMoreWidgets);
    expect(find.text('Góc cảnh báo'), findsOneOrMoreWidgets);
  });

  testWidgets('Tab switching test', (WidgetTester tester) async {
    await tester.pumpWidget(const FinancialGuideApp());

    // Find and tap the "Góc cảnh báo" tab
    await tester.tap(find.text('Góc cảnh báo'));
    await tester.pumpAndSettle();

    // Verify warning tab content is displayed
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('Financial tips list test', (WidgetTester tester) async {
    await tester.pumpWidget(const FinancialGuideApp());

    // Wait for the list to be built
    await tester.pumpAndSettle();

    // Verify that financial tips are displayed
    expect(find.text('Tiết kiệm thông minh'), findsOneOrMoreWidgets);
  });
}
