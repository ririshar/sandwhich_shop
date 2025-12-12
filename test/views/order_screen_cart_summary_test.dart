import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('OrderScreen shows cart summary banner',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Cart summary banner from common_widgets.dart
    expect(find.byKey(const Key('cart_summary')), findsOneWidget);
  });
}
