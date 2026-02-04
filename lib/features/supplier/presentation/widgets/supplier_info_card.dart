import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Floating card displaying supplier information over the banner.
class SupplierInfoCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback? onInfoTap;

  const SupplierInfoCard({super.key, required this.supplier, this.onInfoTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Positioned(
      bottom: context.units.h(10),
      left: context.units.w(16),
      right: context.units.w(16),
      child: Container(
        padding: EdgeInsets.all(context.units.w(10)),
        decoration: BoxDecoration(
          color: context.cs.surface.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(context.units.r(16)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Supplier logo
            _SupplierLogo(supplier: supplier),
            SizedBox(width: context.units.w(12)),
            // Supplier info
            Expanded(
              child: _SupplierInfo(supplier: supplier, l10n: l10n),
            ),
            // Info button
            IconButton(
              icon: Icon(
                IconsaxPlusLinear.information,
                color: context.cs.onSurface,
              ),
              onPressed: onInfoTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// Supplier logo widget.
class _SupplierLogo extends StatelessWidget {
  final Supplier supplier;

  const _SupplierLogo({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.units.w(50),
      height: context.units.w(50),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.cs.outline.withValues(alpha: 0.2),
          width: 2,
        ),
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
                size: context.units.sp(20),
                color: context.cs.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Supplier information section (name, delivery time, rating).
class _SupplierInfo extends StatelessWidget {
  final Supplier supplier;
  final dynamic l10n;

  const _SupplierInfo({required this.supplier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          supplier.name,
          style: TextStyle(
            fontSize: context.units.sp(16),
            fontWeight: FontWeight.bold,
            color: context.cs.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: context.units.h(4)),
        Row(
          children: [
            Icon(
              IconsaxPlusLinear.clock,
              size: context.units.sp(12),
              color: context.cs.onSurfaceVariant,
            ),
            SizedBox(width: context.units.w(4)),
            Text(
              '${supplier.deliveryTimeMin} ${l10n.searchMinDelivery}',
              style: context.tt.labelMedium,
            ),
            SizedBox(width: context.units.w(12)),
            Icon(
              IconsaxPlusBold.star_1,
              size: context.units.sp(12),
              color: const Color(0xFFFFB800),
            ),
            SizedBox(width: context.units.w(4)),
            Text(
              supplier.rating.toStringAsFixed(1),
              style: context.tt.titleSmall,
            ),
          ],
        ),
      ],
    );
  }
}
