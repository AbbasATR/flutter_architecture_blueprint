import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/widgets/order_card.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.cs.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.l10n.orders,
          style: context.tt.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: isDark ? context.cs.primary : context.cs.primary,
          labelColor: isDark ? context.cs.primary : context.cs.onSurface,
          unselectedLabelColor: context.cs.onSurface.withValues(alpha: 0.6),
          labelStyle: context.tt.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: context.tt.titleSmall,
          tabs: [
            Tab(text: context.l10n.activeOrders),
            Tab(text: context.l10n.pastOrders),
          ],
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: context.tt.subTitleMedium),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(RefreshOrdersEvent());
                    },
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          } else if (state is OrderLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                // Active Orders Tab
                _buildOrdersList(
                  context,
                  state.activeOrders,
                  context.l10n.noOrders,
                ),
                // Past Orders Tab
                _buildOrdersList(
                  context,
                  state.pastOrders,
                  context.l10n.noOrders,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<dynamic> orders,
    String emptyMessage,
  ) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            emptyMessage,
            style: context.tt.subTitleLarge.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderBloc>().add(RefreshOrdersEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderCard(order: orders[index]),
          );
        },
      ),
    );
  }
}
