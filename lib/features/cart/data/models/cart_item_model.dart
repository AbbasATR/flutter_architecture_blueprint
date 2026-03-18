import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/item/data/models/item_model.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.item,
    required super.quantity,
    super.selectedSize,
    required super.sizePrice,
    super.specialInstructions,
    required super.addedAt,
  });

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      item: entity.item,
      quantity: entity.quantity,
      selectedSize: entity.selectedSize,
      sizePrice: entity.sizePrice,
      specialInstructions: entity.specialInstructions,
      addedAt: entity.addedAt,
    );
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      item: ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      selectedSize: json['selectedSize'] as String?,
      sizePrice: (json['sizePrice'] as num).toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      item: item,
      quantity: quantity,
      selectedSize: selectedSize,
      sizePrice: sizePrice,
      specialInstructions: specialInstructions,
      addedAt: addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': ItemModel.fromEntity(item).toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'sizePrice': sizePrice,
      'specialInstructions': specialInstructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  @override
  CartItemModel copyWith({
    String? id,
    Item? item,
    int? quantity,
    String? selectedSize,
    double? sizePrice,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      sizePrice: sizePrice ?? this.sizePrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
