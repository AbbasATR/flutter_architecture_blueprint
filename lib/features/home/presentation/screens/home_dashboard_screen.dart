import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/widgets/item_list_section.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/widgets/restaurant_list_section.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Restaurant Group Section
        const SliverToBoxAdapter(child: RestaurantListSection()),

        // Saves Section
        const SliverToBoxAdapter(child: ItemListSection(isSaved: true)),

        // New Listings Section
        const SliverToBoxAdapter(child: ItemListSection(isSaved: false)),
        SliverToBoxAdapter(child: SizedBox(height: context.units.h(20))),
      ],
    );
  }
}
