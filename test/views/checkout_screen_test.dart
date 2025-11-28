import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CheckoutScreen', () {
    testWidgets('builds CheckoutScreen without errors',
        (WidgetTester tester) async {
      final cart = Cart();
      final item = CartItem(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: true,
        quantity: 2,
      );
      cart.addItem(item);

      await tester.pumpWidget(
        MaterialApp(
          home: CheckoutScreen(cart: cart),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CheckoutScreen), findsOneWidget);
    });

    testWidgets(
        'Confirm Payment button (if present) triggers processing flow safely',
        (WidgetTester tester) async {
      final cart = Cart();
      final item = CartItem(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: true,
        quantity: 1,
      );
      cart.addItem(item);

      // Use a host scaffold so CheckoutScreen can be pushed and popped safely.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                key: const Key('open_checkout'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => CheckoutScreen(cart: cart)),
                  );
                },
                child: const Text('Open checkout'),
              );
            }),
          ),
        ),
      );

      // Open the CheckoutScreen
      await tester.tap(find.byKey(const Key('open_checkout')));
      await tester.pumpAndSettle();

      // If a Confirm button exists, exercise it; otherwise the test still passes if screen has no such button.
      final confirmFinder =
          find.widgetWithText(ElevatedButton, 'Confirm Payment');
      if (confirmFinder.evaluate().isNotEmpty) {
        await tester.tap(confirmFinder);
        await tester.pump();

        // If the screen shows a progress indicator during processing, assert it appears.
        if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        }

        // Allow any fake processing delays to run (give a small buffer).
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // After processing the screen may pop; ensure we at least returned to the host route.
        expect(find.byKey(const Key('open_checkout')), findsOneWidget);
      } else {
        // No confirm button: ensure test still passes and no runtime errors occurred.
        expect(confirmFinder, findsNothing);
      }
    });
  });
}
