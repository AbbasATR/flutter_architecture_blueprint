import 'package:flutter_architecture_blueprint/features/home/data/models/home_brand_model.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_category_model.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_menu_item_model.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';

class HomeBootstrapModel extends HomeBootstrap {
  const HomeBootstrapModel({
    required super.categories,
    required super.brands,
    required super.savedItems,
    required super.newListings,
  });

  factory HomeBootstrapModel.fromJson(Map<String, dynamic> json) {
    return HomeBootstrapModel(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => HomeCategoryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      brands:
          (json['brands'] as List<dynamic>?)
              ?.map((e) => HomeBrandModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      savedItems:
          (json['saved_items'] as List<dynamic>?)
              ?.map(
                (e) => HomeMenuItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      newListings:
          (json['new_listings'] as List<dynamic>?)
              ?.map(
                (e) => HomeMenuItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories
          .map((e) => HomeCategoryModel.fromEntity(e).toJson())
          .toList(),
      'brands': brands
          .map((e) => HomeBrandModel.fromEntity(e).toJson())
          .toList(),
      'saved_items': savedItems
          .map((e) => HomeMenuItemModel.fromEntity(e).toJson())
          .toList(),
      'new_listings': newListings
          .map((e) => HomeMenuItemModel.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory HomeBootstrapModel.fromEntity(HomeBootstrap entity) {
    return HomeBootstrapModel(
      categories: entity.categories,
      brands: entity.brands,
      savedItems: entity.savedItems,
      newListings: entity.newListings,
    );
  }
}
