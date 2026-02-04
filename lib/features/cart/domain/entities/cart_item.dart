import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';

/// Represents an item in the shopping cart
class CartItem extends Equatable {
  final String id;
  final Item item;
  final int quantity;
  final String? selectedSize;
  final double sizePrice;
  final String? specialInstructions;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.item,
    required this.quantity,
    this.selectedSize,
    required this.sizePrice,
    this.specialInstructions,
    required this.addedAt,
  });

  /// Calculate total price for this cart item (including size price)
  double get totalPrice => (item.price + sizePrice) * quantity;

  /// Calculate base item price (per unit)
  double get unitPrice => item.price + sizePrice;

  CartItem copyWith({
    String? id,
    Item? item,
    int? quantity,
    String? selectedSize,
    double? sizePrice,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      sizePrice: sizePrice ?? this.sizePrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    item,
    quantity,
    selectedSize,
    sizePrice,
    specialInstructions,
    addedAt,
  ];
}
