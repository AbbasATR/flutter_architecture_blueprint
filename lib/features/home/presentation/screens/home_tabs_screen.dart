import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_tab.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/widgets/utils/category_chip.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_list_view.dart';
import 'package:flutter_architecture_blueprint/injection/injection_container.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

class HomeTabsScreen extends StatefulWidget {
  const HomeTabsScreen({super.key});

  @override
  State<HomeTabsScreen> createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: HomeTab.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; // keep list state when switching bottom tabs

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar is now in ShellScreen - removed from here

          // Categories - Fixed
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: context.units.h(112),
              maxHeight: context.units.h(112),
              child: AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  return TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    isScrollable: true,

                    tabAlignment: TabAlignment.start,

                    tabs: [
                      for (int i = 0; i < HomeTab.values.length; i++)
                        CategoryChip(
                          label: HomeTab.values[i].label,
                          isSelected: _tabController.index == i,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // JET Dashboard - show existing dashboard
                HomeDashboardScreen(),

                // Restaurants tab - show supplier list
                BlocProvider(
                  create: (_) => sl<SupplierBloc>(),
                  child: SupplierListView(
                    businessType: HomeTab.restaurants.businessType!,
                  ),
                ),

                // Shopping tab - show supplier list
                BlocProvider(
                  create: (_) => sl<SupplierBloc>(),
                  child: SupplierListView(
                    businessType: HomeTab.shopping.businessType!,
                  ),
                ),

                // Grocery tab - show supplier list
                BlocProvider(
                  create: (_) => sl<SupplierBloc>(),
                  child: SupplierListView(
                    businessType: HomeTab.grocery.businessType!,
                  ),
                ),

                // Flowers tab - show supplier list
                BlocProvider(
                  create: (_) => sl<SupplierBloc>(),
                  child: SupplierListView(
                    businessType: HomeTab.flowers.businessType!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom delegate for pinned headers
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
