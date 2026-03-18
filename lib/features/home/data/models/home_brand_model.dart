import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_brand.dart';

class HomeBrandModel extends AppBrand {
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

  factory HomeBrandModel.fromEntity(AppBrand entity) {
    return HomeBrandModel(
      id: entity.id,
      name: entity.name,
      tagline: entity.tagline,
      imageAsset: entity.imageAsset,
      backgroundColor: entity.backgroundColor,
    );
  }

  AppBrand toEntity() => AppBrand(
    id: id,
    name: name,
    tagline: tagline,
    imageAsset: imageAsset,
    backgroundColor: backgroundColor,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'image_asset': imageAsset,
    'background_color': backgroundColor,
  };
}
