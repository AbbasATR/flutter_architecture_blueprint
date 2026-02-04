import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_category.dart';

class HomeCategoryModel extends HomeCategory {
  const HomeCategoryModel({
    required super.id,
    required super.label,
    required super.iconAsset,
    super.backgroundColor,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      id: json['id'] as String,
      label: json['label'] as String,
      iconAsset: json['icon_asset'] as String,
      backgroundColor: json['background_color'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon_asset': iconAsset,
      'background_color': backgroundColor,
    };
  }

  factory HomeCategoryModel.fromEntity(HomeCategory entity) {
    return HomeCategoryModel(
      id: entity.id,
      label: entity.label,
      iconAsset: entity.iconAsset,
      backgroundColor: entity.backgroundColor,
    );
  }
}
