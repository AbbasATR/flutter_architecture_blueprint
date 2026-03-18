import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_brand.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_category.dart';
import 'package:flutter_architecture_blueprint/core/app_bootstrap/entities/app_menu_item.dart';

class AppBootstrap extends Equatable {
  const AppBootstrap({
    required this.categories,
    required this.brands,
    required this.savedItems,
    required this.newListings,
  });

  final List<AppCategory> categories;
  final List<AppBrand> brands;
  final List<AppMenuItem> savedItems;
  final List<AppMenuItem> newListings;

  @override
  List<Object?> get props => [categories, brands, savedItems, newListings];
}
