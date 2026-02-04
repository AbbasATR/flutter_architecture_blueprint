import 'package:flutter/material.dart';

class RestaurantListSection extends StatelessWidget {
  const RestaurantListSection({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;

    // final restaurants = [
    //   {
    //     'name': 'Turath',
    //     'subtitle': 'Oriental Food Restaurant',
    //     'image': 'assets/images/atr_restaurants/turath.png',
    //   },
    //   {
    //     'name': 'Food Fort',
    //     'subtitle': 'Fast Food Restaurant',
    //     'image': 'assets/images/atr_restaurants/food_fort.png',
    //   },
    //   {
    //     'name': 'Arido',
    //     'subtitle': 'Fast Food Restaurant',
    //     'image': 'assets/images/atr_restaurants/arido.png',
    //   },
    // ];
    return SizedBox.shrink();
    // return Column(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.all(20),
    //       child: Row(
    //         children: [
    //           Text(l10n.alakrakchyGroup, style: context.tt.titleMedium),
    //         ],
    //       ),
    //     ),
    //     SizedBox(
    //       height: context.units.screenW / 2.4,
    //       child: ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
    //         itemCount: restaurants.length,
    //         itemBuilder: (context, index) {
    //           final restaurant = restaurants[index];
    //           return RestaurantCard(
    //             name: restaurant['name'] as String,
    //             subtitle: restaurant['subtitle'] as String,
    //             imageUrl: restaurant['image'] as String,
    //             onTap: () {
    //               // Hide shell app bar and bottom nav
    //               final bottomNavCubit = context.read<BottomNavCubit>();
    //               bottomNavCubit.hide();

    //
    //               final supplier = Supplier(
    //                 id: index + 1,
    //                 name: restaurant['name'] as String,
    //                 slogan: restaurant['subtitle'] as String,
    //                 state: SupplierState.active,
    //                 latLong: '25.2048,55.2708', // Default Dubai coordinates
    //                 businessType: SupplierBusinessType.restaurant,
    //                 logoURL: restaurant['image'] as String,
    //                 bannerURL: restaurant['image'] as String,
    //                 addressDescription: 'Dubai, UAE',
    //                 minOrderAmount: 20.0,
    //                 deliveryFeeBase: 5.0,
    //                 operatingInfo: {},
    //                 rating: 4.5,
    //                 reviewCount: 100,
    //                 deliveryTimeMin: 30,
    //               );

    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) =>
    //                       SupplierDetailScreen(supplier: supplier),
    //                 ),
    //               ).then((_) {
    //                 // Show shell app bar and bottom nav when returning
    //                 bottomNavCubit.show();
    //               });
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
