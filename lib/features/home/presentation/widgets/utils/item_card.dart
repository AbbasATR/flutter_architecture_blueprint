import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String restaurant;
  final String price;
  final String imageUrl;
  final double rating;
  final String time;
  final String distance;
  final bool isSaved;
  final bool hasDiscount;
  final String? discountText;
  final VoidCallback? onTap;
  final VoidCallback? onSaveToggle;

  const ItemCard({
    super.key,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.time = '',
    this.distance = '',
    this.isSaved = false,
    this.hasDiscount = false,
    this.discountText,
    this.onTap,
    this.onSaveToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: context.units.w(150),

        child: Card(
          elevation: 0.5,
          color: context.cs.surfaceContainer,
          margin: EdgeInsetsDirectional.only(end: context.units.w(30)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Content - Left side
              Padding(
                padding: EdgeInsets.all(context.units.w(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section - Title and Save icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 11),
                              Text(
                                name,
                                style: context.tt.titleSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: context.units.h(2)),
                              Text(
                                restaurant,
                                style: context.tt.subTitleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    IconsaxPlusLinear.clock,
                                    size: context.units.r(12),
                                    color: context.cs.onSurfaceVariant,
                                  ),
                                  SizedBox(width: context.units.w(4)),
                                  Expanded(
                                    child: Text(
                                      time,
                                      style: context.tt.subTitleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Bottom section - Rating, Time, and Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating and Time
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.star,
                        //       size: context.units.r(14),
                        //       color: Colors.amber,
                        //     ),
                        //     SizedBox(width: context.units.w(4)),
                        //     Text(
                        //       rating.toString(),
                        //       style: context.tt.labelMedium,
                        //     ),
                        //     SizedBox(width: context.units.w(8)),
                        //   ],
                        // ),
                        // circle image
                        ClipOval(
                          child: Image.asset(
                            'assets/images/atr_restaurants/food_fort.png',
                            width: context.units.w(25),
                            height: context.units.w(25),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: context.units.h(8)),
                        // Price
                        Text(price, style: context.tt.titleSmall),
                      ],
                    ),
                  ],
                ),
              ),

              // Image - Right side (unchanged position)
              PositionedDirectional(
                end: -30,
                bottom: 7,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(context.units.r(50)),
                  ),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: context.units.h(90),
                  ),
                ),
              ),

              // Discount Badge - Top right corner
              if (hasDiscount && discountText != null)
                PositionedDirectional(
                  top: context.units.h(4),
                  end: context.units.w(4),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.units.w(2),
                      vertical: context.units.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(context.units.r(12)),
                    ),
                    child: Text(
                      discountText!,
                      style: context.tt.labelMedium.copyWith(
                        color: Colors.white,
                        letterSpacing: -1,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
