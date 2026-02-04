import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_bloc.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_event.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_cart_bottom_bar.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_category_tabs.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_detail_app_bar.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/widgets/supplier_items_list.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Screen displaying supplier details and their items.
class SupplierDetailScreen extends StatefulWidget {
  final Supplier supplier;

  const SupplierDetailScreen({super.key, required this.supplier});

  @override
  State<SupplierDetailScreen> createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showTitle = false;

  // Category tabs based on Food Fort menu
  static const _tabs = [
    'Recommended',
    'Burgers',
    'Sandwiches',
    'Shawarma',
    'Saj',
    'Pizza',
    'Ria',
    'Salads',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Load items when screen opens
    context.read<ItemBloc>().add(LoadItems(widget.supplier.id));
  }

  void _onScroll() {
    // Show title when scrolled more than 160 pixels (before banner is fully collapsed)
    final showTitle =
        _scrollController.hasClients &&
        _scrollController.offset > (context.units.h(160));
    if (showTitle != _showTitle) {
      setState(() {
        _showTitle = showTitle;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with banner
          SupplierDetailAppBar(
            supplier: widget.supplier,
            showTitle: _showTitle,
          ),

          // Category tabs
          SupplierCategoryTabs(tabController: _tabController, tabs: _tabs),

          // Items list
          const SupplierItemsList(),
        ],
      ),
      // Bottom cart button
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          int itemCount = 0;
          double totalPrice = 0;
          double subtotalPrice = 0;

          if (cartState is CartLoaded) {
            itemCount = cartState.totalItems;
            totalPrice = cartState.totalPrice;
            // Calculate subtotal (original price before discount - for now same as total)
            subtotalPrice = cartState.totalPrice;
          } else if (cartState is CartOperationSuccess) {
            itemCount = cartState.totalItems;
            totalPrice = cartState.totalPrice;
            subtotalPrice = cartState.totalPrice;
          }

          // Only show if there are items in cart
          if (itemCount == 0) {
            return const SizedBox.shrink();
          }

          return SupplierCartBottomBar(
            itemCount: itemCount,
            totalPrice: '${totalPrice.toStringAsFixed(0)} IQD',
            subtotalPrice: '${subtotalPrice.toStringAsFixed(0)} IQD',
            onViewCartTap: () {
              // Navigate back to shell and switch to cart tab
              context.read<BottomNavCubit>().setTab(BottomTab.cart);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
