import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_brand.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_category.dart';

class AppBootstrap extends Equatable {
  final List<HomeCategory> categories;
  final List<HomeBrand> brands;
  final List<String> savedItems;
  final List<String> newListings;

  const AppBootstrap({
    required this.categories,
    required this.brands,
    required this.savedItems,
    required this.newListings,
  });

  factory AppBootstrap.fromHomeBootstrap(HomeBootstrap bootstrap) {
    return AppBootstrap(
      categories: bootstrap.categories,
      brands: bootstrap.brands,
      savedItems: bootstrap.savedItems,
      newListings: bootstrap.newListings,
    );
  }

  HomeBootstrap toHomeBootstrap() {
    return HomeBootstrap(
      categories: categories,
      brands: brands,
      savedItems: savedItems,
      newListings: newListings,
    );
  }

  @override
  List<Object> get props => [categories, brands, savedItems, newListings];
}
