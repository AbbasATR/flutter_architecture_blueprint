/// Enum representing the status of an item.
enum ItemStatus {
  /// Item is in draft state
  drafted,

  /// Item is available for order
  available,

  /// Item is temporarily unavailable
  unavailable,

  /// Item is archived
  archived;

  /// Get display name for the item status
  String get displayName {
    switch (this) {
      case ItemStatus.drafted:
        return 'Drafted';
      case ItemStatus.available:
        return 'Available';
      case ItemStatus.unavailable:
        return 'Unavailable';
      case ItemStatus.archived:
        return 'Archived';
    }
  }
}
