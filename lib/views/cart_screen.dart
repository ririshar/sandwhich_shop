import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final PricingRepository _pricing = PricingRepository();

  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: widget.cart),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String;
      final String estimatedTime = result['estimatedTime'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  void _removeItem(CartItem item) {
    setState(() {
      widget.cart.removeItem(item);
    });
  }

  void _removeOne(CartItem item) {
    setState(() {
      widget.cart.removeOne(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: heading1),
      ),
      body: items.isEmpty
          ? Center(child: Text('Your cart is empty', style: normalText))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final it = items[i];
                final sandwich = Sandwich(
                  type: it.type,
                  isFootlong: it.isFootlong,
                  breadType: it.breadType,
                );
                final lineTotal =
                    _pricing.totalPrice(it.quantity, isFootlong: it.isFootlong);
                final lineTotalStr = _pricing.formatPrice(lineTotal);

                return Card(
                  child: SizedBox(
                    height: 110, // increase height so item box is larger
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 92,
                            height: 92,
                            child: Image.asset(
                              sandwich.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${it.quantity} × ${sandwich.name}',
                                    style: normalText),
                                const SizedBox(height: 6),
                                Text(
                                  '${it.breadType.name} • ${it.isFootlong ? 'footlong' : 'six-inch'}${it.toasted ? ' • toasted' : ''}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(lineTotalStr, style: heading1),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _removeOne(it),
                                    tooltip: 'Remove one',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _removeItem(it),
                                    tooltip: 'Remove item',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Material(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.shopping_cart),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Items: ${widget.cart.totalQuantity}',
                  style: normalText,
                ),
              ),
              Text(widget.cart.formattedTotal(), style: heading1),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed:
                    widget.cart.items.isEmpty ? null : _navigateToCheckout,
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
