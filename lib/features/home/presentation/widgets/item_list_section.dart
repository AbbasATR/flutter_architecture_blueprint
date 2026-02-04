import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/screens/item_detail_screen.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/widgets/utils/item_card.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class ItemListSection extends StatelessWidget {
  final bool isSaved;

  const ItemListSection({super.key, required this.isSaved});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final foods = [
      {
        'name': 'Vegetable Pizza',
        'restaurant': 'Crisp, Colorful',
        'price': '13,000 IQD',
        'rating': 4.5,
        'time': '32 - 45 min',
        'distance': '32 - 45 min',
        'image': 'assets/images/food/food1.png',
        'hasDiscount': isSaved,
        'discountText': '25%',
      },
      {
        'name': 'Salads',
        'restaurant': 'Crisp, Colorful',
        'price': '7,000 IQD',
        'rating': 4.3,
        'time': '32 - 45 min',
        'distance': '32 - 45 min',
        'image': 'assets/images/food/food2.png',
        'hasDiscount': isSaved,
        'discountText': '25%',
      },
      {
        'name': 'Salads',
        'restaurant': 'Crisp, Colorful',
        'price': '13,000 IQD',
        'rating': 4.2,
        'time': '32 - 45 min',
        'distance': '32 - 45 min',
        'image': 'assets/images/food/food2.png',
        'hasDiscount': false,
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(l10n.saves, style: context.tt.titleMedium),
              const Spacer(),
              Text(
                l10n.seeAll,
                style: context.tt.titleMedium.copyWith(
                  color: context.cs.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.units.h(160),
          width: context.units.screenW,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return ItemCard(
                name: food['name'] as String,
                restaurant: food['restaurant'] as String,
                price: food['price'] as String,
                rating: food['rating'] as double,
                time: food['time'] as String,
                distance: food['distance'] as String,
                imageUrl: food['image'] as String,
                isSaved: isSaved,
                hasDiscount: food['hasDiscount'] as bool,
                discountText: food['discountText'] as String?,
                onTap: () {
                  // Hide shell app bar and bottom nav
                  final bottomNavCubit = context.read<BottomNavCubit>();
                  bottomNavCubit.hide();

                  // TODO: Replace with actual item data from backend
                  final item = Item(
                    id: index + 1,
                    name: food['name'] as String,
                    shortDescription: food['restaurant'] as String,
                    description:
                        'Delicious ${food['name']} with fresh ingredients. ${food['restaurant']}',
                    imageURL: food['image'] as String,
                    price: double.parse(
                      (food['price'] as String)
                          .replaceAll(' IQD', '')
                          .replaceAll(',', ''),
                    ),
                    categoryId: 1,
                    supplierId: 1,
                    isAvailable: true,
                    rating: food['rating'] as double,
                    reviewCount: 50,
                    updatedAt: DateTime.now(),
                    type: ItemType.food,
                    metadata: {},
                    prepTimeMinutes: 30,
                    status: ItemStatus.available,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(item: item),
                    ),
                  ).then((_) {
                    // Show shell app bar and bottom nav when returning
                    bottomNavCubit.show();
                  });
                },
                onSaveToggle: () {
                  // Handle save toggle
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
