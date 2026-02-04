import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Search text field widget with clear button
///
/// A specialized text field for search functionality with:
/// - Auto-focus on mount
/// - Clear button when text is present
/// - Localized hint text
/// - Optimized for search UX
class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  void initState() {
    super.initState();
    // Listen to text changes to rebuild and show/hide clear button
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Rebuild to show/hide clear button
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: context.units.h(45),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          hintStyle: TextStyle(
            color: context.cs.onSurfaceVariant,
            fontSize: context.units.sp(14),
          ),
          prefixIcon: Icon(
            IconsaxPlusLinear.search_normal,
            color: context.cs.onSurfaceVariant,
            size: context.units.w(20),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    IconsaxPlusLinear.close_circle,
                    color: context.cs.onSurfaceVariant,
                    size: context.units.w(20),
                  ),
                  onPressed: widget.onClear,
                  tooltip: l10n.close,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.units.w(16),
            vertical: context.units.h(12),
          ),
        ),
        style: TextStyle(
          fontSize: context.units.sp(14),
          color: context.cs.onSurface,
        ),
      ),
    );
  }
}
