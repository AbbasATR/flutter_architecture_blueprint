import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Empty state widget for search results
class SearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isError;

  const SearchEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: context.units.w(64),
            color: isError
                ? context.cs.error
                : context.cs.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: context.units.h(16)),
          Text(
            message,
            style: TextStyle(
              fontSize: context.units.sp(16),
              color: context.cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
