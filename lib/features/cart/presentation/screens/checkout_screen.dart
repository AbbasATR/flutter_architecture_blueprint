import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod selectedPaymentMethod = PaymentMethod.cashOnDelivery;
  final double deliveryFee = 2000; // Fixed delivery fee
  final double tax = 0; // No tax for now

  @override
  void initState() {
    super.initState();
    // Hide bottom navigation bar when entering checkout
    context.read<BottomNavCubit>().hide();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.subtotal + deliveryFee + tax;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        // Show bottom navigation bar when going back
        if (didPop) {
          context.read<BottomNavCubit>().show();
        }
      },
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          title: Text(
            context.l10n.checkout,
            style: context.tt.titleLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: custom.FloatingActionButton(
            icon: IconsaxPlusLinear.undo,
            onTap: () {
              context.read<BottomNavCubit>().show();
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderCreateSuccess) {
              // Clear cart and navigate back
              context.read<CartBloc>().add(const ClearCartEvent());
              context.read<BottomNavCubit>().show();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pop(context);
            } else if (state is OrderCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Deliver to section
                      _buildDeliverToSection(context),

                      const SizedBox(height: 24),

                      // Delivery time section
                      _buildDeliveryTimeSection(context),

                      const SizedBox(height: 24),

                      // Payment method section
                      _buildPaymentMethodSection(context),

                      const SizedBox(height: 32),

                      // Price breakdown
                      _buildPricingBreakdown(context, total),
                    ],
                  ),
                ),
              ),

              // Place order button
              _buildPlaceOrderButton(context, total),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliverToSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceBright,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              IconsaxPlusLinear.location,
              color: context.cs.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.deliverTo,
                  style: context.tt.labelMedium.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.work, // Mock address
                  style: context.tt.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Karbala, Hussain / Alatakelchy Company', // Mock address
                  style: context.tt.labelMedium.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            IconsaxPlusLinear.edit_2,
            size: 20,
            color: context.cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceBright,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(IconsaxPlusLinear.clock, color: context.cs.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.deliveryTime,
                  style: context.tt.labelMedium.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.now,
                  style: context.tt.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            IconsaxPlusLinear.edit_2,
            size: 20,
            color: context.cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surfaceBright,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              IconsaxPlusLinear.card_pos,
              color: context.cs.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.paymentMethod,
                  style: context.tt.labelMedium.copyWith(
                    color: context.cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.cashOnDelivery,
                  style: context.tt.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            IconsaxPlusLinear.edit_2,
            size: 20,
            color: context.cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingBreakdown(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cs.surfaceBright,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            context,
            label: context.l10n.subtotal,
            value: '${widget.subtotal.toStringAsFixed(0)} IQD',
            originalValue: '${(widget.subtotal + 4000).toStringAsFixed(0)} IQD',
            isDiscounted: true,
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            context,
            label: context.l10n.tax,
            value: '${tax.toStringAsFixed(0)} IQD',
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            context,
            label: '${context.l10n.deliveryFee}:',
            value: '${deliveryFee.toStringAsFixed(0)} IQD',
          ),
          const Divider(height: 32),
          _buildPriceRow(
            context,
            label: context.l10n.total,
            value: '${total.toStringAsFixed(0)} IQD',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String label,
    required String value,
    String? originalValue,
    bool isDiscounted = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold)
              : context.tt.labelLarge.copyWith(
                  color: context.cs.onSurfaceVariant,
                ),
        ),
        Row(
          children: [
            if (isDiscounted && originalValue != null) ...[
              Text(
                originalValue,
                style: context.tt.labelMedium.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: context.cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              value,
              style: isTotal
                  ? context.tt.titleMedium.copyWith(fontWeight: FontWeight.bold)
                  : context.tt.labelLarge.copyWith(
                      color: isDiscounted ? Colors.green : context.cs.onSurface,
                      fontWeight: isDiscounted ? FontWeight.w600 : null,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        boxShadow: [
          BoxShadow(
            color: context.cs.onSurface.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final isLoading = state is OrderCreating;

            return SubmitButton(
              text: context.l10n.placeOrder,
              icon: Icons.shopping_cart_checkout,
              onPressed: isLoading ? null : () => _placeOrder(context),
            );
          },
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    context.read<OrderBloc>().add(
      CreateOrderEvent(
        cartItems: widget.cartItems,
        deliveryAddress:
            'Karbala, Hussain / Alatakelchy Company', // Mock address
        paymentMethod: selectedPaymentMethod,
        subtotal: widget.subtotal,
        deliveryFee: deliveryFee,
        notes: null,
      ),
    );
  }
}
