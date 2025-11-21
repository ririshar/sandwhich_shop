import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }
      expect(find.text('5 white footlong sandwich(es): 🥪🥪🥪🥪🥪'),
          findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();
      expect(
          find.textContaining('wholemeal footlong sandwich'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra mayo');
      await tester.pump();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });

    testWidgets('Switch toggles between six-inch and footlong',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
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

    testWidgets('toggles size and toasted switches',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final sizeSwitch = find.byKey(const Key('size_switch'));
      expect(sizeSwitch, findsOneWidget);

      // toggle size switch
      await tester.tap(sizeSwitch);
      await tester.pumpAndSettle();
      expect(find.textContaining('six-inch'), findsWidgets);

      // for the toasted switch test:
      final toastSwitch = find.byKey(const Key('toasted_switch'));
      expect(toastSwitch, findsOneWidget);
      await tester.tap(toastSwitch);
      await tester.pumpAndSettle();
      // assert UI reacts accordingly (add expectation for 'toasted' state text if present)
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });


  group('OrderScreen - interaction smoke tests', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(OrderScreen), findsOneWidget);
    });

    testWidgets('increments and decrements quantity with icon buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final addFinder = find.byIcon(Icons.add).first;
      final removeFinder = find.byIcon(Icons.remove).first;

      // initial quantity shown in UI (matches _quantity in state)
      expect(find.text('1'), findsWidgets);

      // increment
      await tester.tap(addFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // decrement
      await tester.tap(removeFinder);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // decrement to zero and ensure it doesn't go negative
      await tester.tap(removeFinder);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      await tester.tap(removeFinder);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('size Switch toggles its value', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch).first;
      expect(switchFinder, findsOneWidget);

      // read current value
      Switch sw = tester.widget<Switch>(switchFinder);
      final initial = sw.value;

      // toggle
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      sw = tester.widget<Switch>(switchFinder);
      expect(sw.value, isNot(initial));
    });

    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final dropdownFinder = find.byType(DropdownMenu<BreadType>);
      expect(dropdownFinder, findsOneWidget);

      // Open dropdown
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Select 'wheat' (menu entries use bread.name)
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat'), findsWidgets);

      // Open again and select 'wholemeal'
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wholemeal'), findsWidgets);
    });
  });
}
