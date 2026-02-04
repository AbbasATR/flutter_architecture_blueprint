import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isNumeric;
  final Widget? icon;
  final bool isPassword;
  final Widget? suffix;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final bool requiredField;
  final int? minLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isNumeric = false,
    this.icon,
    this.isPassword = false,
    this.suffix,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.requiredField = false,
    this.minLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.units.h(10),
        horizontal: context.units.w(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.units.h(75)),

        child: TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: isPassword ? 1 : maxLines,
          keyboardType:
              keyboardType ??
              (isNumeric ? TextInputType.number : TextInputType.text),
          obscureText: isPassword,
          textInputAction: isPassword
              ? TextInputAction.done
              : TextInputAction.next,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
              : [],
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: context.units.h(15),
              horizontal: context.units.w(5),
            ),
            label: RichText(
              text: TextSpan(
                children: [
                  if (requiredField)
                    TextSpan(
                      text: '* ',
                      style: TextStyle(color: context.cs.error),
                    ),
                  TextSpan(
                    text: label,
                    style: TextStyle(color: context.cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: context.cs.tertiary),
            prefixIcon: icon,
            suffixIcon: suffix,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator:
              validator ??
              (value) {
                if (requiredField && (value == null || value.trim().isEmpty)) {
                  return '${AppStrings.pleaseEnter} $label';
                }
                if (minLength != null && (value?.length ?? 0) < minLength!) {
                  return '${AppStrings.pleaseEnterAtLeast} $minLength ${AppStrings.characters} $label';
                }
                return null;
              },
          onFieldSubmitted: onFieldSubmitted,
        ),
      ),
    );
  }
}
