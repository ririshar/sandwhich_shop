import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/main.dart' show ProfileScreen, StyledButton;

/// A standard app bar used across screens, with logo, title and optional actions.
PreferredSizeWidget buildStandardAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Image.asset(
          'assets/images/logo.png',
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.fastfood, color: Colors.white),
        ),
      ),
    ),
    title: Text(title, style: heading1),
    actions: actions,
  );
}

/// A standard drawer with navigation to Profile and About.
Drawer buildAppDrawer(BuildContext context) {
  return Drawer(
    key: const Key('app_drawer'),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: const Text(
            'Menu',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        ListTile(
          key: const Key('drawer_profile'),
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {
            Navigator.of(context).pop(); // close drawer
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
        ),
        ListTile(
          key: const Key('drawer_about'),
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
          },
        ),
      ],
    ),
  );
}

/// A reusable cart summary row (e.g. at bottom or in the body).
class CartSummaryBanner extends StatelessWidget {
  final Cart cart;

  const CartSummaryBanner({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('cart_summary'),
      color: Colors.pink.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.pink),
                const SizedBox(width: 8),
                Text(
                  'Cart: ${cart.countOfItems} item${cart.countOfItems == 1 ? '' : 's'}',
                  style: normalText,
                ),
              ],
            ),
            Text(
              '£${cart.totalPrice().toStringAsFixed(2)}',
              style: heading1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable “View Cart” button.
class ViewCartButton extends StatelessWidget {
  final Cart cart;

  const ViewCartButton({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return StyledButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => CartScreen(cart: cart),
          ),
        );
      },
      icon: Icons.shopping_cart,
      label: 'View Cart',
      backgroundColor: Colors.blue,
    );
  }
}
