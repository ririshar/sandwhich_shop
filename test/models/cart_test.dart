import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart / CartItem', () {
    late PricingRepository pricing;
    late Cart cart;

    setUp(() {
      pricing = PricingRepository();
      cart = Cart(pricing: pricing);
    });

    test('addItem merges identical items and updates quantities', () {
      final itemA = CartItem(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: true,
        quantity: 1,
      );

      cart.addItem(itemA);
      expect(cart.lineCount, 1);
      expect(cart.totalQuantity, 1);

      // add identical item (should merge)
      cart.addItem(CartItem(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: true,
        quantity: 2,
      ));

      expect(cart.lineCount, 1);
      expect(cart.totalQuantity, 3);
    });

    test('removeOne decreases quantity and removes when quantity reaches 0',
        () {
      final item = CartItem(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: false,
        quantity: 2,
      );

      cart.addItem(item);
      expect(cart.lineCount, 1);
      expect(cart.totalQuantity, 2);

      cart.removeOne(item);
      expect(cart.lineCount, 1);
      expect(cart.totalQuantity, 1);

      cart.removeOne(item);
      expect(cart.lineCount, 0);
      expect(cart.totalQuantity, 0);
    });

    test('removeItem removes the entire line', () {
      final a = CartItem(
        type: SandwichType.tunaMelt,
        breadType: BreadType.wholemeal,
        isFootlong: true,
        quantity: 1,
      );
      final b = CartItem(
        type: SandwichType.meatballMarinara,
        breadType: BreadType.white,
        isFootlong: false,
        quantity: 1,
      );

      cart.addItem(a);
      cart.addItem(b);
      expect(cart.lineCount, 2);

      cart.removeItem(a);
      expect(cart.lineCount, 1);
      expect(cart.items.first.type, SandwichType.meatballMarinara);
    });

    test('updateQuantity sets quantity or removes when <= 0', () {
      final item = CartItem(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: true,
        quantity: 1,
      );
      cart.addItem(item);
      expect(cart.totalQuantity, 1);

      cart.updateQuantity(item, 5);
      expect(cart.totalQuantity, 5);

      cart.updateQuantity(item, 0);
      expect(cart.lineCount, 0);
      expect(cart.totalQuantity, 0);
    });

    test('totalPrice and formattedTotal use PricingRepository', () {
      // footlong price = 11.0, six-inch = 7.0
      final footlong = CartItem(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.white,
        isFootlong: true,
        quantity: 2,
      );
      final sixInch = CartItem(
        type: SandwichType.tunaMelt,
        breadType: BreadType.wheat,
        isFootlong: false,
        quantity: 3,
      );

      cart.addItem(footlong); // 2 * 11 = 22
      cart.addItem(sixInch); // 3 * 7 = 21

      expect(cart.totalPrice(), 43.0);
      expect(cart.formattedTotal(), '£43.00');
    });

    test('toJson/fromJson round trip preserves items and totals', () {
      final a = CartItem(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: true,
        quantity: 2,
        note: 'No onions',
      );
      final b = CartItem(
        type: SandwichType.tunaMelt,
        breadType: BreadType.wheat,
        isFootlong: false,
        quantity: 1,
      );

      cart.addItem(a);
      cart.addItem(b);

      final map = cart.toJson();
      final restored = Cart.fromJson(map, pricingRepository: pricing);

      expect(restored.lineCount, cart.lineCount);
      expect(restored.totalQuantity, cart.totalQuantity);
      expect(restored.formattedTotal(), cart.formattedTotal());
      // Ensure note and identifying fields round-trip
      expect(restored.items.any((it) => it.note == 'No onions'), isTrue);
    });
  });
}
