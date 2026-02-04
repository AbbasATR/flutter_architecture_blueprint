/// Enum representing the type of an item.
enum ItemType {
  /// Food items
  food,

  /// Drink items
  drink,

  /// Dessert items
  dessert,

  /// Appetizer items
  appetizer,

  /// Side items
  side,

  /// Other items
  other;

  /// Get display name for the item type
  String get displayName {
    switch (this) {
      case ItemType.food:
        return 'Food';
      case ItemType.drink:
        return 'Drink';
      case ItemType.dessert:
        return 'Dessert';
      case ItemType.appetizer:
        return 'Appetizer';
      case ItemType.side:
        return 'Side';
      case ItemType.other:
        return 'Other';
    }
  }
}
