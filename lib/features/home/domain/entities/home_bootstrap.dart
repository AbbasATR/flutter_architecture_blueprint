import 'package:equatable/equatable.dart';
import 'home_brand.dart';
import 'home_category.dart';
import 'home_menu_item.dart';

class HomeBootstrap extends Equatable {
  const HomeBootstrap({
    required this.categories,
    required this.brands,
    required this.savedItems,
    required this.newListings,
  });

  final List<HomeCategory> categories;
  final List<HomeBrand> brands;
  final List<HomeMenuItem> savedItems;
  final List<HomeMenuItem> newListings;

  @override
  List<Object?> get props => [categories, brands, savedItems, newListings];
}
