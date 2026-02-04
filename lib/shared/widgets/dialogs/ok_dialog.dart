import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/constants/app_strings.dart';

void okDialog(
  BuildContext context,
  String message, {
  String? title,
  IconData? icon,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(icon ?? Icons.warning, size: 30, color: Colors.amber.shade800),
          const SizedBox(width: 8),
          Text(title ?? 'تنبيه'),
        ],
      ),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.close),
        ),
      ],
    ),
  );
}
