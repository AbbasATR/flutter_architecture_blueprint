import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget for entering special instructions for an item
class ItemSpecialInstructions extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ItemSpecialInstructions({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(context.units.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.specialInstructions,
            style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: context.units.h(12)),
          TextField(
            onChanged: onChanged,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.writeHere,
              hintStyle: context.tt.labelMedium.copyWith(
                color: context.cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.units.r(12)),
                borderSide: BorderSide(
                  color: context.cs.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.units.r(12)),
                borderSide: BorderSide(
                  color: context.cs.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.units.r(12)),
                borderSide: BorderSide(color: context.cs.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
