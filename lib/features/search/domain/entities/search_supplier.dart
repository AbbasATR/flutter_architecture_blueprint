import 'package:equatable/equatable.dart';

/// Represents a searchable supplier (restaurant/shop)
class SearchSupplier extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double? rating;
  final int? reviewCount;
  final String? deliveryTime;
  final double? deliveryFee;

  const SearchSupplier({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.rating,
    this.reviewCount,
    this.deliveryTime,
    this.deliveryFee,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    category,
    rating,
    reviewCount,
    deliveryTime,
    deliveryFee,
  ];
}
