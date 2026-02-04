import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelBuilder;
  final Color? bgColor;

  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? context.cs.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),

      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: selectedItem,
          hint: Center(
            child: Text(
              AppStrings.choose,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(Icons.arrow_drop_down, color: Colors.black),
          ),
          iconSize: 25,
          elevation: 1,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: Text(
                  itemLabelBuilder(item),
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
        ),
      ),
    );
  }
}
