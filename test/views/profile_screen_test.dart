import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  group('ProfileScreen', () {
    testWidgets('renders name, email, phone fields and save button',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // required fields
      expect(find.byKey(const Key('profile_name')), findsOneWidget);
      expect(find.byKey(const Key('profile_email')), findsOneWidget);
      expect(find.byKey(const Key('profile_phone')), findsOneWidget);
      expect(find.byKey(const Key('profile_save')), findsOneWidget);

      // optional username/password may or may not exist; assert only if present
      if (find.byKey(const Key('profile_username')).evaluate().isNotEmpty) {
        expect(find.byKey(const Key('profile_username')), findsOneWidget);
      }
      if (find.byKey(const Key('profile_password')).evaluate().isNotEmpty) {
        expect(find.byKey(const Key('profile_password')), findsOneWidget);
      }
    });

    testWidgets('enter valid data and tap Save shows confirmation',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      final nameFinder = find.byKey(const Key('profile_name'));
      final emailFinder = find.byKey(const Key('profile_email'));
      final phoneFinder = find.byKey(const Key('profile_phone'));
      final saveFinder = find.byKey(const Key('profile_save'));

      // ensure the required fields exist before interacting
      expect(nameFinder, findsOneWidget);
      expect(emailFinder, findsOneWidget);
      expect(phoneFinder, findsOneWidget);
      expect(saveFinder, findsOneWidget);

      await tester.enterText(nameFinder, 'Alice');
      await tester.enterText(emailFinder, 'alice@example.com');
      await tester.enterText(phoneFinder, '07123456789');

      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      // Expect a SnackBar with success message (implementation shows this)
      expect(find.text('Profile saved'), findsOneWidget);
    });

    testWidgets('invalid email prevents save and shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      final nameFinder = find.byKey(const Key('profile_name'));
      final emailFinder = find.byKey(const Key('profile_email'));
      final saveFinder = find.byKey(const Key('profile_save'));

      expect(nameFinder, findsOneWidget);
      expect(emailFinder, findsOneWidget);
      expect(saveFinder, findsOneWidget);

      await tester.enterText(nameFinder, 'Bob');
      await tester.enterText(emailFinder, 'not-an-email');

      await tester.tap(saveFinder);
      await tester.pumpAndSettle();

      // Implementation may show an inline message or a SnackBar with 'Invalid email'
      // Check for either possibility by looking for 'Invalid' or exact string.
      final invalidTextFinder = find.text('Invalid email');
      final genericInvalidFinder =
          find.textContaining('invalid', findRichText: false);

      expect(
          invalidTextFinder.evaluate().isNotEmpty ||
              genericInvalidFinder.evaluate().isNotEmpty,
          isTrue,
          reason:
              'Expected an invalid-email error message (inline or SnackBar).');
    });
  });
}
