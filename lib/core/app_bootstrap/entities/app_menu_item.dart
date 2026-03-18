import 'package:equatable/equatable.dart';

class AppMenuItem extends Equatable {
  const AppMenuItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.currency,
    required this.rating,
    required this.deliveryTime,
    required this.imageAsset,
    this.discount,
    this.isSaved = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String currency;
  final double rating;
  final String deliveryTime;
  final String imageAsset;
  final int? discount;
  final bool isSaved;

  @override
  List<Object?> get props => [
    id,
    name,
    subtitle,
    price,
    currency,
    rating,
    deliveryTime,
    imageAsset,
    discount,
    isSaved,
  ];
}
