import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';

Widget borderButton({
  required String text,
  required VoidCallback? onPressed,
  required BuildContext context,
  IconData? icon,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      side: BorderSide(color: context.cs.primary, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      backgroundColor: context.cs.primary,
      foregroundColor: Colors.black,
    ),

    onPressed: onPressed,
    icon: icon != null ? Icon(icon) : const Icon(Icons.add),
    label: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );
}
