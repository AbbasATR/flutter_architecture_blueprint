/// Business type classification for suppliers.
enum SupplierBusinessType {
  /// Restaurant - food and beverages
  restaurant,

  /// Shopping - retail stores
  shopping,

  /// Grocery - supermarkets and food stores
  grocery,

  /// Flowers - flower shops and florists
  flowers,

  /// Pharmacy - pharmacies and drugstores
  pharmacy,

  /// Electronics - electronics and gadgets
  electronics,

  /// Other - catch-all for other business types
  other;

  /// Get display name for the business type
  String get displayName {
    switch (this) {
      case SupplierBusinessType.restaurant:
        return 'Restaurant';
      case SupplierBusinessType.shopping:
        return 'Shopping';
      case SupplierBusinessType.grocery:
        return 'Grocery';
      case SupplierBusinessType.flowers:
        return 'Flowers';
      case SupplierBusinessType.pharmacy:
        return 'Pharmacy';
      case SupplierBusinessType.electronics:
        return 'Electronics';
      case SupplierBusinessType.other:
        return 'Other';
    }
  }
}
