# Task: Implement cart modification features (prompt for LLM)

Context
- Flutter app with two screens:
  - Order screen: `lib/main.dart` — users select sandwiches and add to cart.
  - Cart screen: `lib/views/cart_screen.dart` — shows `Cart.items` and totals.
- Cart model: `lib/models/cart.dart` (Cart, CartItem).
- Pricing logic: `lib/repositories/pricing_repository.dart`.
- Constraint: use only built‑in Flutter widgets (no third‑party packages).

Goal
Ask the LLM to implement UI + logic so users can modify items in the cart from the CartScreen. For each feature below, explain exactly what should happen, what to change in code, acceptance criteria and tests to add.

Features (for the prompt)

1) Increase / decrease quantity (line item)
- Description: Add [+] and [−] controls on each cart row to change that line's quantity.
- Behavior:
  - Tap [+]: increment quantity by 1, call `Cart.updateQuantity(item, newQty)` or `Cart.addItem(...)` so `Cart` logic handles merging and limits. Update UI via `setState`.
  - Tap [−]: if quantity > 1 decrement; if quantity == 1 remove the line (`Cart.removeItem`) or prompt (see remove feature). Update UI and totals immediately.
  - Respect a `maxQuantity` rule if present; disable [+] when reached.
- UI details & keys:
  - Add IconButton `Icon(Icons.add)` with `Key('cart_inc_$i')` and `Icon(Icons.remove)` with `Key('cart_dec_$i')`.
  - Show updated line total and refresh cart summary at top/bottom.
- Acceptance criteria / tests:
  - Widget test: tap inc twice → quantity increases accordingly and cart total updates.
  - Widget test: tap dec until removed → line disappears and totals update.
  - Unit test: `Cart.updateQuantity` updates internal state and `totalPrice()` returns expected value.

2) Remove item entirely (delete)
- Description: Add a delete action to remove the whole line.
- Behavior:
  - Tap delete icon → call `Cart.removeItem(item)` and `setState`.
  - Optionally show SnackBar or MaterialBanner with UNDO that re-adds the removed item for a short time.
- UI details & keys:
  - Add IconButton `Icon(Icons.delete)` with `Key('cart_delete_$i')`.
  - If UNDO: keep a temporary `removedItem` copy and restore on UNDO.
- Acceptance criteria / tests:
  - Widget test: tap delete → line removed and totals updated.
  - Widget test (if UNDO): tap delete then tap UNDO → item restored.

3) Edit item options (size, bread, toasted, note)
- Description: Allow editing an existing CartItem’s options.
- Behavior:
  - Provide an Edit button that opens a modal (use `showModalBottomSheet` or `showDialog`) where the user can change size, bread, toasted, and note, and save/cancel.
  - On Save: if edited options match an existing line, merge quantities (call `Cart.addItem` appropriately), otherwise update the existing CartItem (e.g., change fields on the item in-place).
  - Update totals and UI immediately.
- UI details & keys:
  - Edit button `IconButton(Icons.edit)` with `Key('cart_edit_$i')`.
  - Modal contains the same controls as OrderScreen (Switch for size, DropdownMenu for bread, Switch for toasted, TextField for note).
- Acceptance criteria / tests:
  - Widget test: open edit modal, change size/bread, save → verify totals and line merging behavior.

4) Direct quantity input (optional)
- Description: Allow typing a quantity directly.
- Behavior:
  - When user taps quantity text, swap to a `TextField` with numeric keyboard. On commit, validate and call `Cart.updateQuantity`.
  - Validate integer bounds and show inline error for invalid input.
- UI details & keys:
  - `TextField` with `Key('cart_qty_input_$i')`.
- Acceptance criteria:
  - Widget test: enter '3' → line quantity becomes 3 and totals update.

5) Persistent updates & UI consistency
- Description: Ensure the same `Cart` instance is shared between OrderScreen and CartScreen so updates are reflected everywhere immediately.
- Behavior:
  - Pass `Cart` by reference to `CartScreen(cart: _cart)`; do not pass copies.
  - After edits and pop, OrderScreen summary must reflect updated `Cart`.
- Acceptance criteria / tests:
  - Widget test: add item on OrderScreen → navigate to CartScreen → edit quantity → pop back → OrderScreen summary shows updated totals.

6) Accessibility & feedback
- Description: Add `tooltip` and semantic labels for buttons and announce important changes with a SnackBar or MaterialBanner.
- Acceptance criteria:
  - Buttons have tooltips; important actions optionally show brief banners/snackbars.

Implementation guidance (for LLM)
- Files to change:
  - `lib/views/cart_screen.dart`: implement item row UI changes, edit modal, and setState calls.
  - (Optional) `lib/models/cart.dart`: ensure methods `addItem`, `removeOne`, `removeItem`, `updateQuantity`, `totalPrice`, `formattedTotal` exist and behave as expected.
  - Tests: add widget tests under `test/views/cart_screen_test.dart` and/or update `test/models/cart_test.dart`.
- Use only `package:flutter/material.dart` and existing app code/APIs.
- Use keys for testability:
  - Row container: `Key('cart_item_$i')`
  - Increment button: `Key('cart_inc_$i')`
  - Decrement button: `Key('cart_dec_$i')`
  - Delete button: `Key('cart_delete_$i')`
  - Edit button: `Key('cart_edit_$i')`
  - Summary container: `Key('cart_summary')`
- Tests to add (examples):
  - test/views/cart_screen_test.dart
    - test 'increment updates quantity and totals'
    - test 'decrement removes line and updates totals'
    - test 'delete removes and undo restores' (if UNDO implemented)
    - test 'edit merges into existing line when options match'
  - Use `WidgetTester` to navigate: pump App(), tap 'View Cart', perform actions, assert UI text and formatted price (e.g., '£11.00').
- Formatting: use `PricingRepository.formatPrice()` for displayed totals.

Developer notes for applying the changes
- Keep UI simple and consistent with existing styles (`normalText`, `heading1`, `heading2`).
- Prefer `showModalBottomSheet` for edit modal — simpler to implement and dismiss.
- Manage temporary state inside `CartScreenState` (e.g., `_removedItemForUndo`, controllers for note).
- Always call `setState` after mutating `Cart` so UI updates.

Deliverables requested from the LLM
1. Code diff or full-file edits for `lib/views/cart_screen.dart` implementing the UI + logic above.
2. Any small changes required in `lib/models/cart.dart` (explicitly stated).
3. Test files: at least 3 widget tests that exercise increment, decrement/remove, and edit/merge behavior.
4. Exact widget keys to use for tests.

Keep the implementation minimal and focused on correctness and testability.// filepath: c:\Users\riris\Desktop\Test Project\sandwhich_shop\prompt.md
# Task: Implement cart modification features (prompt for LLM)

Context
- Flutter app with two screens:
  - Order screen: `lib/main.dart` — users select sandwiches and add to cart.
  - Cart screen: `lib/views/cart_screen.dart` — shows `Cart.items` and totals.
- Cart model: `lib/models/cart.dart` (Cart, CartItem).
- Pricing logic: `lib/repositories/pricing_repository.dart`.
- Constraint: use only built‑in Flutter widgets (no third‑party packages).

Goal
Ask the LLM to implement UI + logic so users can modify items in the cart from the CartScreen. For each feature below, explain exactly what should happen, what to change in code, acceptance criteria and tests to add.

Features (for the prompt)

1) Increase / decrease quantity (line item)
- Description: Add [+] and [−] controls on each cart row to change that line's quantity.
- Behavior:
  - Tap [+]: increment quantity by 1, call `Cart.updateQuantity(item, newQty)` or `Cart.addItem(...)` so `Cart` logic handles merging and limits. Update UI via `setState`.
  - Tap [−]: if quantity > 1 decrement; if quantity == 1 remove the line (`Cart.removeItem`) or prompt (see remove feature). Update UI and totals immediately.
  - Respect a `maxQuantity` rule if present; disable [+] when reached.
- UI details & keys:
  - Add IconButton `Icon(Icons.add)` with `Key('cart_inc_$i')` and `Icon(Icons.remove)` with `Key('cart_dec_$i')`.
  - Show updated line total and refresh cart summary at top/bottom.
- Acceptance criteria / tests:
  - Widget test: tap inc twice → quantity increases accordingly and cart total updates.
  - Widget test: tap dec until removed → line disappears and totals update.
  - Unit test: `Cart.updateQuantity` updates internal state and `totalPrice()` returns expected value.

2) Remove item entirely (delete)
- Description: Add a delete action to remove the whole line.
- Behavior:
  - Tap delete icon → call `Cart.removeItem(item)` and `setState`.
  - Optionally show SnackBar or MaterialBanner with UNDO that re-adds the removed item for a short time.
- UI details & keys:
  - Add IconButton `Icon(Icons.delete)` with `Key('cart_delete_$i')`.
  - If UNDO: keep a temporary `removedItem` copy and restore on UNDO.
- Acceptance criteria / tests:
  - Widget test: tap delete → line removed and totals updated.
  - Widget test (if UNDO): tap delete then tap UNDO → item restored.

3) Edit item options (size, bread, toasted, note)
- Description: Allow editing an existing CartItem’s options.
- Behavior:
  - Provide an Edit button that opens a modal (use `showModalBottomSheet` or `showDialog`) where the user can change size, bread, toasted, and note, and save/cancel.
  - On Save: if edited options match an existing line, merge quantities (call `Cart.addItem` appropriately), otherwise update the existing CartItem (e.g., change fields on the item in-place).
  - Update totals and UI immediately.
- UI details & keys:
  - Edit button `IconButton(Icons.edit)` with `Key('cart_edit_$i')`.
  - Modal contains the same controls as OrderScreen (Switch for size, DropdownMenu for bread, Switch for toasted, TextField for note).
- Acceptance criteria / tests:
  - Widget test: open edit modal, change size/bread, save → verify totals and line merging behavior.

4) Direct quantity input (optional)
- Description: Allow typing a quantity directly.
- Behavior:
  - When user taps quantity text, swap to a `TextField` with numeric keyboard. On commit, validate and call `Cart.updateQuantity`.
  - Validate integer bounds and show inline error for invalid input.
- UI details & keys:
  - `TextField` with `Key('cart_qty_input_$i')`.
- Acceptance criteria:
  - Widget test: enter '3' → line quantity becomes 3 and totals update.

5) Persistent updates & UI consistency
- Description: Ensure the same `Cart` instance is shared between OrderScreen and CartScreen so updates are reflected everywhere immediately.
- Behavior:
  - Pass `Cart` by reference to `CartScreen(cart: _cart)`; do not pass copies.
  - After edits and pop, OrderScreen summary must reflect updated `Cart`.
- Acceptance criteria / tests:
  - Widget test: add item on OrderScreen → navigate to CartScreen → edit quantity → pop back → OrderScreen summary shows updated totals.

6) Accessibility & feedback
- Description: Add `tooltip` and semantic labels for buttons and announce important changes with a SnackBar or MaterialBanner.
- Acceptance criteria:
  - Buttons have tooltips; important actions optionally show brief banners/snackbars.

Implementation guidance (for LLM)
- Files to change:
  - `lib/views/cart_screen.dart`: implement item row UI changes, edit modal, and setState calls.
  - (Optional) `lib/models/cart.dart`: ensure methods `addItem`, `removeOne`, `removeItem`, `updateQuantity`, `totalPrice`, `formattedTotal` exist and behave as expected.
  - Tests: add widget tests under `test/views/cart_screen_test.dart` and/or update `test/models/cart_test.dart`.
- Use only `package:flutter/material.dart` and existing app code/APIs.
- Use keys for testability:
  - Row container: `Key('cart_item_$i')`
  - Increment button: `Key('cart_inc_$i')`
  - Decrement button: `Key('cart_dec_$i')`
  - Delete button: `Key('cart_delete_$i')`
  - Edit button: `Key('cart_edit_$i')`
  - Summary container: `Key('cart_summary')`
- Tests to add (examples):
  - test/views/cart_screen_test.dart
    - test 'increment updates quantity and totals'
    - test 'decrement removes line and updates totals'
    - test 'delete removes and undo restores' (if UNDO implemented)
    - test 'edit merges into existing line when options match'
  - Use `WidgetTester` to navigate: pump App(), tap 'View Cart', perform actions, assert UI text and formatted price (e.g., '£11.00').
- Formatting: use `PricingRepository.formatPrice()` for displayed totals.

Developer notes for applying the changes
- Keep UI simple and consistent with existing styles (`normalText`, `heading1`, `heading2`).
- Prefer `showModalBottomSheet` for edit modal — simpler to implement and dismiss.
- Manage temporary state inside `CartScreenState` (e.g., `_removedItemForUndo`, controllers for note).
- Always call `setState` after mutating `Cart` so UI updates.

Deliverables requested from the LLM
1. Code diff or full-file edits for `lib/views/cart_screen.dart` implementing the UI + logic above.
2. Any small changes required in `lib/models/cart.dart` (explicitly stated).
3. Test files: at least 3 widget tests that exercise increment, decrement/remove, and edit/merge behavior.
4. Exact widget keys to use for tests.

Keep the implementation minimal and focused on correctness and testability.