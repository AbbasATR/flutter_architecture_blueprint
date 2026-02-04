import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_brand.dart';

class HomeBrandModel extends HomeBrand {
  const HomeBrandModel({
    required super.id,
    required super.name,
    required super.tagline,
    required super.imageAsset,
    super.backgroundColor,
  });

  factory HomeBrandModel.fromJson(Map<String, dynamic> json) {
    return HomeBrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      imageAsset: json['image_asset'] as String,
      backgroundColor: json['background_color'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'image_asset': imageAsset,
      'background_color': backgroundColor,
    };
  }

  factory HomeBrandModel.fromEntity(HomeBrand entity) {
    return HomeBrandModel(
      id: entity.id,
      name: entity.name,
      tagline: entity.tagline,
      imageAsset: entity.imageAsset,
      backgroundColor: entity.backgroundColor,
    );
  }
}
