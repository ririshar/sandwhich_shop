GitHub Copilot
GitHub Copilot

Cart Modification Feature — Requirements
1. Feature overview
Provide in‑app controls so users can modify items already added to their cart from the CartScreen. The feature must let users change line quantity, remove lines, edit item options (size, bread, toasted, note), and optionally input quantity directly. All changes must update the cart totals immediately and persist while the app runs (OrderScreen and CartScreen share the same Cart instance). Use only built‑in Flutter widgets.

2. Purpose
Allow customers to adjust their order without leaving the cart UI, reducing friction and supporting common flows (increase quantity, correct choices, remove unwanted items). Keep behavior predictable and testable.

3. Subtasks (high level)
Subtask A — Quantity controls (increment/decrement)
Subtask B — Remove item (delete + optional UNDO)
Subtask C — Edit item options (modal editor)
Subtask D — Direct quantity input (optional)
Subtask E — Data consistency & sharing (Cart instance)
Subtask F — Accessibility & feedback
Subtask G — Tests and acceptance verification
Each subtask below lists requirements, user stories, and acceptance criteria.

Subtask A — Quantity controls (increment / decrement)
Description

Add [+] and [−] controls on each cart row to increase or decrease that line's quantity.
User stories

As a customer, I want to press + to add one more of that sandwich so I can order multiples quickly.
As a customer, I want to press − to reduce the quantity or remove the item if quantity reaches zero.
Functional requirements

Each cart row must render IconButtons for increment and decrement.
The decrement action:
If quantity > 1: reduce quantity by 1.
If quantity == 1: remove the line (or prompt if undo flow chosen).
The increment action must:
Increase quantity by 1 unless a configurable max is reached.
Disable the increment button when max reached.
After change, update line total and cart summary (total items and formatted total price) immediately.
Acceptance criteria

UI shows increment/decrement buttons for every cart item (use keys: cart_inc_{i}, cart_dec_{i}).
Tapping + increases the displayed line quantity and cart total.
Tapping − decreases quantity. When quantity becomes 0 the line no longer appears.
Unit tests verify Cart.updateQuantity (or addItem/removeOne) and totalPrice behavior.
Subtask B — Remove item entirely (delete)
Description

Provide a delete action to remove a whole cart line.
User stories

As a customer, I want to remove an unwanted item from my cart so I don’t purchase it by mistake.
As a cautious customer, I want an UNDO option after deleting so I can restore a removed item.
Functional requirements

Each cart row must include a delete IconButton (key: cart_delete_{i}).
On delete: remove the CartItem from Cart and call setState() to refresh UI.
Optionally show a short-lived MaterialBanner or SnackBar with an UNDO action; if tapped within the timeout, restore the removed CartItem with original quantity.
Acceptance criteria

Delete removes the line and updates totals immediately.
If UNDO implemented: tapping UNDO within timeout restores the removed item and totals revert.
Tests verify delete and undo behaviors.
Subtask C — Edit item options (size, bread, toasted, note)
Description

Allow editing an existing CartItem’s options via a modal editor.
User stories

As a customer, I want to change size or bread for a specific line without re‑adding it from the order page.
As a customer, I want to edit the note or set toasted on/off for a specific item.
Functional requirements

Each line includes an Edit button (key: cart_edit_{i}) opening a modal (showModalBottomSheet or showDialog).
Modal contains controls matching OrderScreen: size switch, bread dropdown, toasted switch, note TextField, Save and Cancel actions.
On Save:
If the edited item matches an existing line (same identifying attributes excluding quantity), merge quantities (increase existing line quantity).
Otherwise update the item in place.
Immediately refresh UI and totals after Save.
Acceptance criteria

Edit modal opens, allows modifying fields, and Save updates the cart.
If edit merges into an existing line, the previous edited line disappears and quantities combine correctly.
Tests simulate opening modal, changing fields, saving, and asserting totals and line counts.
Subtask D — Direct quantity input (optional)
Description

Let users type exact quantity via a numeric TextField.
User stories

As a user ordering many of the same item, I want to type the desired count rather than pressing + repeatedly.
Functional requirements

Tapping quantity text toggles it into an inline TextField (key: cart_qty_input_{i}) with numeric keyboard.
On commit, validate integer bounds (min 1 or 0 if 0 allowed; enforce max).
Update Cart via updateQuantity and refresh UI.
Acceptance criteria

Typing a valid number updates line quantity and cart totals.
Invalid input shows inline validation and prevents update.
Tests cover entering quantity and verifying totals.
Subtask E — Data consistency & sharing
Description

Ensure Cart state is consistent between OrderScreen and CartScreen.
User stories

As a customer, I want cart changes to be reflected when I navigate between screens.
Functional requirements

OrderScreen must pass the same Cart instance to CartScreen (CartScreen(cart: _cart)).
Modifications in CartScreen mutate the shared Cart instance and UI updates on both screens (on pop back to OrderScreen the cart summary reflects changes).
No copies of items should be modified without updating the Cart object.
Acceptance criteria

Navigation flow test: add item on OrderScreen, go to CartScreen, modify item, go back — OrderScreen summary shows updated totals.
Subtask F — Accessibility & feedback
Description

Add tooltips and brief feedback to assist all users.
Requirements

IconButtons include tooltip strings and semantics where appropriate.
Show brief non-blocking feedback (SnackBar or MaterialBanner) on important actions (delete with undo suggestion).
Ensure color contrast and text sizes follow accessibility basics.
Acceptance criteria

Buttons expose Tooltip widgets.
Critical actions produce brief, visible feedback.
Subtask G — Tests and verification
Description

Add unit and widget tests to ensure correctness and regression safety.
Required tests

Unit tests for Cart model:
addItem merges, updateQuantity updates, removeItem removes, totalPrice returns expected totals.
Widget tests:
Increment button increases line quantity and cart summary (use App root, find keys).
Decrement removes line when reaching zero and updates cart summary.
Delete removes line; UNDO restores it (if implemented).
Edit modal changes fields and merges into existing line when applicable.
Navigation test: modify cart on CartScreen then pop back; OrderScreen summary updates.
Testing details

Use keys: cart_item_{i}, cart_inc_{i}, cart_dec_{i}, cart_delete_{i}, cart_edit_{i}, cart_summary.
Use PricingRepository.formatPrice() to assert formatted totals (e.g., '£11.00').
Non‑functional requirements
Use only built‑in Flutter widgets and material.dart.
Keep UI layout performant and avoid blocking navigation.
Implement minimal state inside CartScreen; rely on Cart model for business logic.
Keep API of Cart unchanged if possible (add methods only if necessary).
Dependencies & constraints
PricingRepository must provide totalPrice(quantity, isFootlong) and formatPrice().
Cart model must expose addItem, removeOne, removeItem, updateQuantity, totalPrice, formattedTotal, items, totalQuantity.
Tests must run with flutter test and not rely on third‑party packages.
Risks & mitigation
Merge semantics on edit could surprise users — mitigate by documenting behavior and showing a banner when merge occurs.
Race conditions if multiple concurrent updates — not expected in single‑user UI.
Asset / localization differences — tests should assert numeric/GBP formatting via repository.
Deliverables
Code edits for cart_screen.dart implementing UI and logic for Subtasks A–E.
Any small, justified changes to cart.dart (documented).
Widget and unit tests as listed in Subtask G.
A short README note describing keys and merge behavior.
If you want, I can now generate the concrete code diffs and test files for Subtask A and B first (increment/decrement + delete + tests). Which subtask should I implement first?

# Profile Screen Feature (verified)

Summary
- Added a simple Profile screen allowing users to enter Name, Email, Phone.
- Navigation from OrderScreen via a "Profile" button (Key: open_profile).
- Save validates input, shows a SnackBar, and returns profile Map via Navigator.pop.

Keys and behavior
- profile_name, profile_email, profile_phone: TextFields.
- profile_save: Save button.
- Validation:
  - Name required.
  - Email must contain '@'.
  - Phone (if provided) digits only.
- On valid save: SnackBar 'Profile saved', Navigator.pop(context, {'name','email','phone'}).

Tests added
- test/views/profile_screen_test.dart covers rendering, successful save, and invalid-email error.

Notes
- No authentication or persistence implemented.
- Uses only Flutter built-in widgets and existing styles.

