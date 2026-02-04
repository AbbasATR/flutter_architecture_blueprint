import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget displaying an item card with image, name, description, and price.
class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.units.w(16),
          vertical: context.units.h(8),
        ),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainer,
          borderRadius: BorderRadius.circular(context.units.r(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Item image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.units.r(12)),
                  bottomLeft: Radius.circular(context.units.r(12)),
                ),
                child: Image.asset(
                  item.imageURL,
                  width: context.units.w(100),
                  height: context.units.h(100),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: context.units.w(100),
                      height: context.units.h(100),
                      color: context.cs.surfaceContainerHighest,
                      child: Icon(
                        IconsaxPlusLinear.gallery,
                        size: context.units.sp(32),
                        color: context.cs.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Item details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.units.w(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      item.name,
                      style: context.tt.titleMedium.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.units.h(4)),
                    // Short description
                    Text(
                      item.shortDescription,
                      style: context.tt.labelMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.units.h(8)),
                    // Price and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '${item.price.toStringAsFixed(0)} IQD',
                          style: context.tt.titleMedium.copyWith(fontSize: 18),
                        ),
                        // Rating
                        Row(
                          children: [
                            Icon(
                              IconsaxPlusBold.star_1,
                              size: context.units.sp(14),
                              color: const Color(0xFFFFB800),
                            ),
                            SizedBox(width: context.units.w(4)),
                            Text(
                              item.rating.toStringAsFixed(1),
                              style: context.tt.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
