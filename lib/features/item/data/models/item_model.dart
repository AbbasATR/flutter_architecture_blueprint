import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';

/// Data model for Item with JSON serialization
class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.supplierId,
    super.categoryId,
    required super.name,
    required super.description,
    required super.shortDescription,
    required super.price,
    required super.updatedAt,
    super.deletedAt,
    required super.freeDelivery,
    required super.isVisible,
    required super.isAvailable,
    required super.type,
    required super.metadata,
    required super.prepTimeMinutes,
    required super.status,
    required super.imageURL,
    required super.rating,
  });

  factory ItemModel.fromEntity(Item entity) {
    return ItemModel(
      id: entity.id,
      supplierId: entity.supplierId,
      categoryId: entity.categoryId,
      name: entity.name,
      description: entity.description,
      shortDescription: entity.shortDescription,
      price: entity.price,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
      freeDelivery: entity.freeDelivery,
      isVisible: entity.isVisible,
      isAvailable: entity.isAvailable,
      type: entity.type,
      metadata: entity.metadata,
      prepTimeMinutes: entity.prepTimeMinutes,
      status: entity.status,
      imageURL: entity.imageURL,
      rating: entity.rating,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      supplierId: json['supplierId'] as int,
      categoryId: json['categoryId'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String,
      price: (json['price'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      freeDelivery: json['freeDelivery'] as bool,
      isVisible: json['isVisible'] as bool,
      isAvailable: json['isAvailable'] as bool,
      type: ItemType.values.firstWhere(
        (e) => e.toString() == 'ItemType.${json['type']}',
        orElse: () => ItemType.food,
      ),
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
      prepTimeMinutes: json['prepTimeMinutes'] as int,
      status: ItemStatus.values.firstWhere(
        (e) => e.toString() == 'ItemStatus.${json['status']}',
        orElse: () => ItemStatus.available,
      ),
      imageURL: json['imageURL'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'price': price,
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'freeDelivery': freeDelivery,
      'isVisible': isVisible,
      'isAvailable': isAvailable,
      'type': type.toString().split('.').last,
      'metadata': metadata,
      'prepTimeMinutes': prepTimeMinutes,
      'status': status.toString().split('.').last,
      'imageURL': imageURL,
      'rating': rating,
    };
  }
}
