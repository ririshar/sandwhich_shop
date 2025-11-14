import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final repo = PricingRepository();

    test('six-inch single price', () {
      expect(repo.totalPrice(1, isFootlong: false), 7.0);
    });

    test('footlong single price', () {
      expect(repo.totalPrice(1, isFootlong: true), 11.0);
    });

    test('multiple quantities compute correctly', () {
      expect(repo.totalPrice(3, isFootlong: false), 21.0);
      expect(repo.totalPrice(2, isFootlong: true), 22.0);
    });

    test('format price', () {
      expect(repo.formatPrice(7.0), '£7.00');
      expect(repo.formatPrice(22.5), '£22.50');
    });
  });
}
