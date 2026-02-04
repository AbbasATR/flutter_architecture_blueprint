import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class SupplierCard extends StatelessWidget {
  final String supplierName;
  final String? supplierImage;
  final DateTime timestamp;
  final bool showRating;

  const SupplierCard({
    super.key,
    required this.supplierName,
    this.supplierImage,
    required this.timestamp,
    required this.showRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cs.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Supplier Logo
          if (supplierImage != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(supplierImage!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: context.cs.onSurface.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.restaurant,
                color: context.cs.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
            ),

          const SizedBox(width: 12),

          // Supplier Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplierName,
                  style: context.tt.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy hh:mm a').format(timestamp),
                  style: context.tt.labelMedium.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Rating Button
          if (showRating)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.rate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
