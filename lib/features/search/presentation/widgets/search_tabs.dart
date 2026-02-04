import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Search tabs widget for Suppliers and Items
class SearchTabs extends StatelessWidget {
  final TabController controller;

  const SearchTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      color: context.cs.surfaceContainer,
      child: TabBar(
        controller: controller,
        indicatorColor: context.cs.primary,
        labelColor: context.cs.primary,
        unselectedLabelColor: context.cs.onSurfaceVariant,
        labelStyle: TextStyle(
          fontSize: context.units.sp(14),
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: context.units.sp(14),
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(text: l10n.searchSuppliers),
          Tab(text: l10n.searchItems),
        ],
      ),
    );
  }
}
