import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_menu_item.dart';

class HomeMenuItemModel extends HomeMenuItem {
  const HomeMenuItemModel({
    required super.id,
    required super.name,
    required super.subtitle,
    required super.price,
    required super.currency,
    required super.rating,
    required super.deliveryTime,
    required super.imageAsset,
    super.discount,
    super.isSaved = false,
  });

  factory HomeMenuItemModel.fromJson(Map<String, dynamic> json) {
    return HomeMenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      rating: (json['rating'] as num).toDouble(),
      deliveryTime: json['delivery_time'] as String,
      imageAsset: json['image_asset'] as String,
      discount: json['discount'] as int?,
      isSaved: json['is_saved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'price': price,
      'currency': currency,
      'rating': rating,
      'delivery_time': deliveryTime,
      'image_asset': imageAsset,
      'discount': discount,
      'is_saved': isSaved,
    };
  }

  factory HomeMenuItemModel.fromEntity(HomeMenuItem entity) {
    return HomeMenuItemModel(
      id: entity.id,
      name: entity.name,
      subtitle: entity.subtitle,
      price: entity.price,
      currency: entity.currency,
      rating: entity.rating,
      deliveryTime: entity.deliveryTime,
      imageAsset: entity.imageAsset,
      discount: entity.discount,
      isSaved: entity.isSaved,
    );
  }
}
