import 'package:flutter/material.dart';

import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Text field for entering address details
class AddressDetailsField extends StatelessWidget {
  final TextEditingController controller;

  const AddressDetailsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.addressDetails,
          style: context.tt.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: context.units.h(8)),
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: context.l10n.enterFullAddress,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.cs.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.cs.primary, width: 2),
            ),
            filled: true,
            fillColor: context.cs.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '${context.l10n.pleaseEnter} ${context.l10n.addressDetails.toLowerCase()}';
            }
            return null;
          },
        ),
      ],
    );
  }
}
