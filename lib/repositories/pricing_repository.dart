class PricingRepository {
  static const double sixInchPrice = 7.0;
  static const double footlongPrice = 11.0;

  /// Calculate total price for given quantity and size.
  double totalPrice(int quantity, {required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    final unitPrice = isFootlong ? footlongPrice : sixInchPrice;
    return unitPrice * quantity;
  }

  /// Format price as GBP string, e.g. "£11.00"
  String formatPrice(double price) => '£${price.toStringAsFixed(2)}';
}
