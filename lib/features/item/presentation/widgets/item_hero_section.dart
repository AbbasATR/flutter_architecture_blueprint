import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Hero section displaying item image with overlaid info card
class ItemHeroSection extends StatelessWidget {
  final Item item;

  const ItemHeroSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.units.screenW / 1.25,
      width: context.units.screenW,
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: context.units.screenW / 1.8,
              width: context.units.screenW,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(context.units.w(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildItemName(context),
                      SizedBox(height: context.units.h(8)),
                      _buildRating(context),
                      SizedBox(height: context.units.h(10)),
                      _buildPrepTime(context),
                      SizedBox(height: context.units.h(5)),
                      if (item.metadata['calories'] != null)
                        _buildCalories(context),
                      const Spacer(),
                      _buildPrice(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildHeroImage(context),
        ],
      ),
    );
  }

  Widget _buildItemName(BuildContext context) {
    return Text(
      item.name,
      style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        Icon(
          IconsaxPlusBold.star_1,
          size: context.units.sp(16),
          color: const Color(0xFFFFB800),
        ),
        SizedBox(width: context.units.w(4)),
        Text(item.rating.toStringAsFixed(1), style: context.tt.titleMedium),
      ],
    );
  }

  Widget _buildPrepTime(BuildContext context) {
    return Row(
      children: [
        Icon(
          IconsaxPlusLinear.clock,
          size: context.units.sp(16),
          color: context.cs.onSurfaceVariant,
        ),
        SizedBox(width: context.units.w(4)),
        Text(
          '${item.prepTimeMinutes} ${context.l10n.searchMinDelivery}',
          style: context.tt.labelMedium.copyWith(
            color: context.cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCalories(BuildContext context) {
    return Row(
      children: [
        Icon(
          IconsaxPlusLinear.activity,
          size: context.units.sp(16),
          color: context.cs.onSurfaceVariant,
        ),
        SizedBox(width: context.units.w(4)),
        Text(
          '${item.metadata['calories']} ${context.l10n.calories}',
          style: context.tt.labelMedium.copyWith(
            color: context.cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Text(
      '${item.price.toStringAsFixed(0)} IQD',
      style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return PositionedDirectional(
      bottom: context.units.w(-25),
      end: context.units.w(-50),
      child: Hero(
        tag: 'item_${item.id}',
        child: ClipRRect(
          child: Image.asset(
            item.imageURL,
            height: context.units.w(300),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: context.units.h(300),
                color: context.cs.surfaceContainerHighest,
                child: Icon(
                  IconsaxPlusLinear.gallery,
                  size: context.units.sp(64),
                  color: context.cs.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
