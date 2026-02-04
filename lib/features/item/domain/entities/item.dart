import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';

/// Entity representing an item/product offered by a supplier.
class Item extends Equatable {
  /// Unique identifier for the item
  final int id;

  /// ID of the supplier offering this item
  final int supplierId;

  /// Category ID (nullable)
  final int? categoryId;

  /// Name of the item
  final String name;

  /// Full description of the item
  final String description;

  /// Short description for preview
  final String shortDescription;

  /// Price of the item
  final double price;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Deletion timestamp (nullable - null means not deleted)
  final DateTime? deletedAt;

  /// Whether this item has free delivery
  final bool freeDelivery;

  /// Whether this item is visible to customers
  final bool isVisible;

  /// Whether this item is available for order
  final bool isAvailable;

  /// Type of the item
  final ItemType type;

  /// Metadata containing additional info (calories, spiciness, etc.)
  final Map<String, dynamic> metadata;

  /// Preparation time in minutes
  final int prepTimeMinutes;

  /// Current status of the item
  final ItemStatus status;

  /// Featured until this date (nullable)
  final DateTime? isFeaturedUntil;

  /// Image URL for the item
  final String imageURL;

  /// Average rating (0-5)
  final double rating;

  /// Number of reviews
  final int reviewCount;

  const Item({
    required this.id,
    required this.supplierId,
    this.categoryId,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.updatedAt,
    this.deletedAt,
    this.freeDelivery = false,
    this.isVisible = true,
    this.isAvailable = true,
    required this.type,
    required this.metadata,
    required this.prepTimeMinutes,
    required this.status,
    this.isFeaturedUntil,
    required this.imageURL,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  /// Check if item is currently featured
  bool get isFeatured {
    if (isFeaturedUntil == null) return false;
    return DateTime.now().isBefore(isFeaturedUntil!);
  }

  @override
  List<Object?> get props => [
    id,
    supplierId,
    categoryId,
    name,
    description,
    shortDescription,
    price,
    updatedAt,
    deletedAt,
    freeDelivery,
    isVisible,
    isAvailable,
    type,
    metadata,
    prepTimeMinutes,
    status,
    isFeaturedUntil,
    imageURL,
    rating,
    reviewCount,
  ];
}
