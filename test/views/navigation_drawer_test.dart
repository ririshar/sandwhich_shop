import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('App drawer opens and navigates to Profile and About',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Try to open the drawer via the AppBar menu button if present,
    // otherwise open it programmatically via ScaffoldState.openDrawer().
    final Finder menuButton = find.byTooltip('Open navigation menu');
    if (menuButton.evaluate().isNotEmpty) {
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
    } else {
      final ScaffoldState scaffoldState =
          tester.firstState(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();
    }

    // Tap Profile entry
    final Finder profileTile = find.byKey(const Key('drawer_profile'));
    expect(profileTile, findsOneWidget);
    await tester.tap(profileTile);
    await tester.pumpAndSettle();

    // Profile screen should be visible (AppBar title 'Profile' expected)
    expect(find.text('Profile'), findsOneWidget);

    // Go back to OrderScreen
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Re-open drawer (same robust method)
    if (menuButton.evaluate().isNotEmpty) {
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
    } else {
      final ScaffoldState scaffoldState =
          tester.firstState(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();
    }

    final Finder aboutTile = find.byKey(const Key('drawer_about'));
    expect(aboutTile, findsOneWidget);
    await tester.tap(aboutTile);
    await tester.pumpAndSettle();

    // About screen content should be visible
    expect(find.text('About Us'), findsOneWidget);
  });
}
