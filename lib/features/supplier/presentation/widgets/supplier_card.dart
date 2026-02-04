import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/screens/supplier_detail_screen.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/injection/injection_container.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget displaying a supplier card with banner, logo, and details.
class SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback? onTap;

  const SupplierCard({super.key, required this.supplier, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap:
          onTap ??
          () {
            // Navigate to supplier detail screen (full screen, no shell)
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => sl<ItemBloc>(),
                  child: SupplierDetailScreen(supplier: supplier),
                ),
              ),
            );
          },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.units.w(16),
          vertical: context.units.h(8),
        ),
        decoration: BoxDecoration(
          color: context.cs.surfaceContainer,
          borderRadius: BorderRadius.circular(context.units.r(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(context.units.r(16)),
                    topRight: Radius.circular(context.units.r(16)),
                  ),
                  child: Image.asset(
                    supplier.bannerURL,
                    width: double.infinity,
                    height: context.units.h(160),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: context.units.h(160),
                        color: context.cs.surfaceContainerHighest,
                        child: Icon(
                          IconsaxPlusLinear.gallery,
                          size: context.units.sp(48),
                          color: context.cs.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
                // Logo overlay (bottom left)
                Positioned(
                  bottom: context.units.h(-20),
                  left: context.units.w(16),
                  child: Container(
                    width: context.units.w(60),
                    height: context.units.w(60),
                    decoration: BoxDecoration(
                      color: context.cs.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.cs.surface, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        supplier.logoURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: context.cs.surfaceContainerHighest,
                            child: Icon(
                              IconsaxPlusLinear.shop,
                              size: context.units.sp(24),
                              color: context.cs.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.units.h(28)),
            // Supplier details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.units.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          supplier.name,
                          style: context.tt.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: context.units.w(8)),
                      Row(
                        children: [
                          Icon(
                            IconsaxPlusBold.star_1,
                            size: context.units.sp(16),
                            color: const Color(0xFFFFB800),
                          ),
                          SizedBox(width: context.units.w(4)),
                          Text(
                            supplier.rating.toStringAsFixed(1),
                            style: context.tt.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.units.h(4)),
                  // Slogan
                  // Text(
                  //   supplier.slogan,
                  //   style: context.tt.subTitleMedium,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  // SizedBox(height: context.units.h(12)),
                  // Delivery info
                  Row(
                    children: [
                      Icon(
                        IconsaxPlusLinear.clock,
                        size: context.units.sp(12),
                        color: context.cs.tertiary,
                      ),
                      SizedBox(width: context.units.w(4)),
                      Text(
                        '${supplier.deliveryTimeMin} ${l10n.searchMinDelivery}',
                        style: context.tt.subTitleMedium,
                      ),
                      SizedBox(width: context.units.w(16)),
                      Icon(
                        IconsaxPlusLinear.dollar_circle,
                        size: context.units.sp(12),
                        color: context.cs.tertiary,
                      ),
                      SizedBox(width: context.units.w(4)),
                      Text(
                        '${(supplier.deliveryFeeBase).toStringAsFixed(0)} IQD',
                        style: context.tt.subTitleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.units.h(16)),
          ],
        ),
      ),
    );
  }
}
