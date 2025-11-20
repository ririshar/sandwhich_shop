import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Represents one line item in the cart.
class CartItem {
  final SandwichType type;
  final BreadType breadType;
  final bool isFootlong;
  final bool toasted;
  final String note;
  int quantity;

  CartItem({
    required this.type,
    required this.breadType,
    required this.isFootlong,
    this.toasted = false,
    this.note = '',
    this.quantity = 1,
  });

  /// Two CartItems are considered the same product if all identifying
  /// attributes except quantity match.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CartItem &&
            other.type == type &&
            other.breadType == breadType &&
            other.isFootlong == isFootlong &&
            other.toasted == toasted &&
            other.note == note);
  }

  @override
  int get hashCode =>
      type.hashCode ^
      breadType.hashCode ^
      isFootlong.hashCode ^
      toasted.hashCode ^
      note.hashCode;

  /// Calculate total price for this line using PricingRepository.
  double lineTotal(PricingRepository pricing) {
    return pricing.totalPrice(quantity, isFootlong: isFootlong);
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'breadType': breadType.name,
        'isFootlong': isFootlong,
        'toasted': toasted,
        'note': note,
        'quantity': quantity,
      };

  static CartItem fromJson(Map<String, dynamic> json) => CartItem(
        type: SandwichType.values.firstWhere((e) => e.name == json['type']),
        breadType:
            BreadType.values.firstWhere((e) => e.name == json['breadType']),
        isFootlong: json['isFootlong'] as bool? ?? true,
        toasted: json['toasted'] as bool? ?? false,
        note: json['note'] as String? ?? '',
        quantity: (json['quantity'] as int?) ?? 1,
      );
}

/// Simple Cart that uses PricingRepository for price calculations.
class Cart {
  final List<CartItem> _items = [];
  final PricingRepository _pricing;

  Cart({PricingRepository? pricing})
      : _pricing = pricing ?? PricingRepository();

  /// All items in the cart (unmodifiable copy).
  List<CartItem> get items => List.unmodifiable(_items);

  /// Add item to the cart. If an identical item exists, increase its quantity.
  void addItem(CartItem item) {
    final index = _items.indexWhere((it) => it == item);
    if (index >= 0) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
  }

  /// Remove one unit of the matching item. If quantity becomes 0, the item is removed.
  void removeOne(CartItem item) {
    final index = _items.indexWhere((it) => it == item);
    if (index >= 0) {
      final current = _items[index];
      if (current.quantity > 1) {
        current.quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  /// Remove an item entirely from the cart (all quantities).
  void removeItem(CartItem item) {
    _items.removeWhere((it) => it == item);
  }

  /// Update quantity for matching item. If q <= 0 the item is removed.
  void updateQuantity(CartItem item, int q) {
    final index = _items.indexWhere((it) => it == item);
    if (index >= 0) {
      if (q > 0) {
        _items[index].quantity = q;
      } else {
        _items.removeAt(index);
      }
    }
  }

  /// Clear cart.
  void clear() => _items.clear();

  /// Total price (unformatted) for the whole cart.
  double totalPrice() {
    double total = 0.0;
    for (final item in _items) {
      total += item.lineTotal(_pricing);
    }
    return total;
  }

  /// Formatted total using PricingRepository.formatPrice
  String formattedTotal() => _pricing.formatPrice(totalPrice());

  /// Number of distinct line items.
  int get lineCount => _items.length;

  /// Total quantity of all units in the cart.
  int get totalQuantity => _items.fold(0, (s, it) => s + it.quantity);

  /// Serialize cart to JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'items': _items.map((i) => i.toJson()).toList(),
      };

  /// Restore a Cart from JSON.
  static Cart fromJson(Map<String, dynamic> json,
      {PricingRepository? pricingRepository}) {
    final cart = Cart(pricing: pricingRepository);
    final items = (json['items'] as List<dynamic>? ?? []);
    for (final raw in items) {
      cart.addItem(CartItem.fromJson(Map<String, dynamic>.from(raw)));
    }
    return cart;
  }
}
