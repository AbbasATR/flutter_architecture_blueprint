import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Dialog to confirm replacing cart items from different supplier
class ReplaceCartDialog extends StatelessWidget {
  final String currentSupplierName;
  final String newSupplierName;

  const ReplaceCartDialog({
    super.key,
    required this.currentSupplierName,
    required this.newSupplierName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.units.r(16)),
      ),
      title: Text(
        context.l10n.replaceCartTitle,
        style: context.tt.titleLarge.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.replaceCartMessage(
              currentSupplierName,
              newSupplierName,
            ),
            style: context.tt.labelLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.l10n.cancel,
            style: context.tt.labelLarge.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.cs.primary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.units.r(8)),
            ),
          ),
          child: Text(
            context.l10n.replaceCart,
            style: context.tt.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
