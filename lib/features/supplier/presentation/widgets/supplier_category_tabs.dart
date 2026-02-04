import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/sliver_app_bar_delegate.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Category tabs section for filtering items.
class SupplierCategoryTabs extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const SupplierCategoryTabs({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: context.units.h(50),
        maxHeight: context.units.h(50),
        child: Container(
          color: context.cs.surface,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: context.cs.primary,
            labelColor: context.cs.onSurface,
            unselectedLabelColor: context.cs.onSurfaceVariant,

            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
      ),
    );
  }
}
