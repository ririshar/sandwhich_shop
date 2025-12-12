import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('Basic Integration Tests', () {
    testWidgets('App launches and shows OrderScreen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: App()));

      // Verify the OrderScreen is displayed
      expect(find.byType(OrderScreen), findsOneWidget);
    });


    testWidgets('Navigate to Cart Screen', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: App()));

      // Tap the button to open Cart Screen
      await tester.tap(find.byKey(const Key('view_cart')));
      await tester.pumpAndSettle();

      // Verify the Cart Screen is displayed
      expect(find.byKey(const Key('cart_screen')), findsOneWidget);
    });
  });
}
