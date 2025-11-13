# Sandwich Shop (Flutter)

A small Flutter demo app that lets a user build a simple sandwich order, adjust quantity, choose bread type, and add an order note. The UI includes an order display, controls to add/remove sandwiches, a bread-type chooser, and a notes TextField. Tests exercise the UI widgets (OrderScreen, OrderItemDisplay, StyledButton).

## Key features
- Increment / decrement sandwich quantity with Add / Remove buttons
- Select sandwich size (Footlong / Six-inch)
- Choose bread type via a DropdownMenu (white, wheat, wholemeal)
- Add a note for special requests (e.g., "no onions")
- Reusable StyledButton and OrderItemDisplay widgets
- Unit/widget tests under `test/`

---

## Installation & Setup

Prerequisites
- Flutter SDK (stable) — https://flutter.dev/docs/get-started/install
- Dart (bundled with Flutter)
- Git
- For web: Chrome (or another supported browser)
- For Windows desktop builds: Visual Studio 2022 (or Build Tools) with "Desktop development with C++" and the Windows SDK (or disable windows desktop support if not needed)

Clone the repo
```bash
git clone https://github.com/ririshar/sandwich_shop.git
cd sandwich_shop
```

Install packages
```bash
flutter pub get
```

Enable web (if you want to run in Chrome)
```bash
flutter config --enable-web
flutter devices    # confirm chrome is listed
```

Run the app
- Run in Chrome (web):
```bash
flutter run -d chrome
```
- Run on a connected device or emulator:
```bash
flutter run
```
- Run Windows desktop (only if VS/MSVC is installed):
```bash
flutter run -d windows
```

If you see CMake / compiler errors on Windows (`No CMAKE_CXX_COMPILER could be found`), install Visual Studio with C++ Desktop workload or disable Windows desktop builds:
```bash
flutter config --no-enable-windows-desktop
```

---

## Usage

Main flows
- Type a note in the "notes" TextField before pressing Add/Remove to attach a note to the current order display.
- Use Add to increment quantity up to the configured max (default 5 in app when launched).
- Use Remove to decrement quantity; the button becomes disabled at zero.
- Use the bread Dropdown to change bread type. The OrderItemDisplay updates to reflect current selection.
- Use the Footlong / Six-inch toggle (or the UI toggle you have) to change sandwich size.

Notes on UI behavior
- Buttons are disabled when their action is not valid (e.g., Add disabled at max, Remove disabled at 0).
- The order note is displayed below the order display when present.
- The order display shows repeated sandwich emoji for the current quantity.

---

## Running tests

Run unit and widget tests:
```bash
flutter test
```

The test suite exercises:
- App startup and the OrderScreen as home
- Quantity increments / decrements and limits
- Bread type selection via DropdownMenu
- Notes TextField behavior
- StyledButton rendering and OrderItemDisplay text formatting

If tests fail, run:
```bash
flutter pub get
flutter analyze
flutter test
```
and inspect the first failing test output for the exact mismatch.

---

## Project structure (overview)

- lib/
  - main.dart                — app entry, widgets: App, OrderScreen, OrderItemDisplay, StyledButton, etc.
  - views/
    - app_styles.dart        — shared TextStyle and theme helpers
  - repositories/
    - order_repository.dart  — simple state/logic for quantity and limits
- test/
  - views/widget_test.dart   — widget tests used by CI/local testing
- pubspec.yaml               — dependencies and metadata
- README.md                  — this file

Key classes
- OrderScreen (StatefulWidget) — main order UI, holds state for quantity, bread, notes
- OrderItemDisplay (StatelessWidget) — renders quantity, bread, type and note
- StyledButton (StatelessWidget) — reusable button with icon/label/style

Dependencies
- flutter
- flutter_lints (development)
- cupertino_icons

---

## Known issues & tips

- Windows desktop builds require an MSVC toolchain (Visual Studio with C++). If you don't need desktop, disable it:
  ```bash
  flutter config --no-enable-windows-desktop
  ```
- If `flutter pub global activate devtools` fails with Dart null-safety errors, run `flutter upgrade` and then retry activation, or use DevTools built into your IDE.
- Some transitive packages may show as "outdated" in `flutter pub outdated`; they are controlled by direct dependency constraints. Use `dependency_overrides` only if you understand the compatibility implications.

Planned improvements
- Persist order history
- Improve responsive layout for small screens
- Add images for sandwich types and enhanced UI polish

---

## Contributing

Contributions welcome. Suggested workflow:
1. Fork the repo
2. Create a branch for your changes:
   ```bash
   git checkout -b feature/my-change
   ```
3. Make changes, add tests
4. Run tests:
   ```bash
   flutter test
   ```
5. Commit and push, then open a Pull Request

Please follow existing code style and run `flutter analyze` before submitting.

---

## Contact

Owner: ririshar (GitHub)
- Repo: https://github.com/ririshar/sandwich_shop


