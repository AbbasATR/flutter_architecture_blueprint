import 'package:equatable/equatable.dart';

/// Represents a searchable item (product/service)
class SearchItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String supplierId;
  final String supplierName;
  final String category;
  final double? rating;

  const SearchItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.supplierId,
    required this.supplierName,
    required this.category,
    this.rating,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    price,
    supplierId,
    supplierName,
    category,
    rating,
  ];
}
