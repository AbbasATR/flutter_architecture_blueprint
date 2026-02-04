import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

class SupplierResultItem extends StatelessWidget {
  final SearchSupplier supplier;

  const SupplierResultItem({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: context.units.w(16),
        vertical: context.units.h(8),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to supplier details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.searchNavigateTo(supplier.name))),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(context.units.w(12)),
          child: Row(
            children: [
              // Supplier Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  supplier.imageUrl,
                  width: context.units.w(80),
                  height: context.units.w(80),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: context.units.w(80),
                      height: context.units.w(80),
                      color: context.cs.surfaceContainerLow,
                      child: Icon(
                        IconsaxPlusLinear.shop,
                        size: context.units.w(32),
                        color: context.cs.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: context.units.w(12)),

              // Supplier Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      style: TextStyle(
                        fontSize: context.units.sp(16),
                        fontWeight: FontWeight.w600,
                        color: context.cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.units.h(4)),
                    Text(
                      supplier.category,
                      style: TextStyle(
                        fontSize: context.units.sp(12),
                        color: context.cs.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: context.units.h(8)),
                    Row(
                      children: [
                        if (supplier.rating != null) ...[
                          Icon(
                            IconsaxPlusBold.star_1,
                            size: context.units.w(14),
                            color: Colors.amber,
                          ),
                          SizedBox(width: context.units.w(4)),
                          Text(
                            supplier.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: context.units.sp(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (supplier.reviewCount != null) ...[
                            Text(
                              ' (${supplier.reviewCount})',
                              style: TextStyle(
                                fontSize: context.units.sp(12),
                                color: context.cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                        if (supplier.deliveryTime != null) ...[
                          SizedBox(width: context.units.w(12)),
                          Icon(
                            IconsaxPlusLinear.clock,
                            size: context.units.w(14),
                            color: context.cs.onSurfaceVariant,
                          ),
                          SizedBox(width: context.units.w(4)),
                          Text(
                            supplier.deliveryTime!,
                            style: TextStyle(
                              fontSize: context.units.sp(12),
                              color: context.cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
