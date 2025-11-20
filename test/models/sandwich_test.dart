import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns human-friendly names', () {
      expect(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Veggie Delight',
      );

      expect(
        Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Chicken Teriyaki',
      );

      expect(
        Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Tuna Melt',
      );

      expect(
        Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.white,
        ).name,
        'Meatball Marinara',
      );
    });

    test('image getter composes asset path using enum name and size', () {
      for (final type in SandwichType.values) {
        final footlong =
            Sandwich(type: type, isFootlong: true, breadType: BreadType.wheat);
        expect(footlong.image, 'assets/images/${type.name}_footlong.png');

        final sixInch =
            Sandwich(type: type, isFootlong: false, breadType: BreadType.wheat);
        expect(sixInch.image, 'assets/images/${type.name}_six_inch.png');
      }
    });
  });
}
