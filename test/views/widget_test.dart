import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';


void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: App()));
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
      await tester.tap(find.byKey(const Key('remove_button')));
      await tester.pumpAndSettle();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      await tester.tap(find.byKey(const Key('remove_button')));
      await tester.pumpAndSettle();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byKey(const Key('add_button')));
        await tester.pumpAndSettle();
      }
      expect(find.text('5 white footlong sandwich(es): 🥪🥪🥪🥪🥪'),
          findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      await tester.tap(find.byKey(const Key('bread_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra mayo');
      await tester.pumpAndSettle();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });

    testWidgets('Switch toggles between six-inch and footlong',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));
      await tester.pumpAndSettle();

      final switchFinder = find.byKey(const Key('size_switch'));
      expect(switchFinder, findsOneWidget);

      // initial should show 'footlong' in the UI
      expect(find.textContaining('footlong'), findsWidgets);

      // toggle to six-inch
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(find.textContaining('six-inch'), findsWidgets);

      // toggle back to footlong
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();
      expect(find.textContaining('footlong'), findsWidgets);
    });
  });

  group('OrderScreen - Add Sandwich to Cart', () {
    testWidgets('adds sandwich and note to cart', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

      // Verify initial state: quantity is 0
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);

      // Tap the "Add" button to increment the quantity
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Verify the quantity has incremented to 1
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);

      // Add a note to the order
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'No onions');
      await tester.pumpAndSettle();

      // Verify the note is displayed
      expect(find.text('Note: No onions'), findsOneWidget);
    });
  });
}
