import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/widgets/dialogs/replace_cart_dialog.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/widgets/item_bottom_cart_bar.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/widgets/item_hero_section.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/widgets/item_size_selector.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/widgets/item_special_instructions.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Screen displaying item details with options to customize and add to cart
class ItemDetailScreen extends StatefulWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  String? _selectedSize;
  int _quantity = 1;
  String _specialInstructions = '';

  final Map<String, double> _sizeOptions = {
    'Small': 0,
    'Medium': 2000,
    'Large': 7000,
  };

  double get _totalPrice {
    final basePrice = widget.item.price;
    final sizePrice = _selectedSize != null ? _sizeOptions[_selectedSize]! : 0;
    return (basePrice + sizePrice) * _quantity;
  }

  @override
  void initState() {
    super.initState();
    _selectedSize = 'Small';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildFloatingButtons(context),
        leading: custom.FloatingActionButton(
          icon: IconsaxPlusLinear.undo,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemHeroSection(item: widget.item),
            _buildDescription(context),
            ItemSizeSelector(
              selectedSize: _selectedSize,
              sizeOptions: _sizeOptions,
              onSizeSelected: (size) => setState(() => _selectedSize = size),
              unavailableSizes: const {'Medium'},
            ),
            ItemSpecialInstructions(
              onChanged: (value) =>
                  setState(() => _specialInstructions = value),
            ),
            SizedBox(height: context.units.h(100)),
          ],
        ),
      ),
      bottomNavigationBar: ItemBottomCartBar(
        quantity: _quantity,
        totalPrice: _totalPrice,
        onIncrement: () => setState(() => _quantity++),
        onDecrement: () => setState(() => _quantity--),
        onAddToCart: _handleAddToCart,
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.units.w(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Row(
              children: [
                custom.FloatingActionButton(
                  icon: IconsaxPlusLinear.share,
                  onTap: () {},
                ),
                custom.FloatingActionButton(
                  icon: IconsaxPlusBold.heart,
                  iconColor: context.cs.error,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.units.w(20)),
      child: Text(widget.item.description, style: context.tt.labelMedium),
    );
  }

  void _handleAddToCart() async {
    // Create cart item
    final cartItem = CartItem(
      id: '${widget.item.id}_${_selectedSize}_${DateTime.now().millisecondsSinceEpoch}',
      item: widget.item,
      quantity: _quantity,
      selectedSize: _selectedSize,
      sizePrice: _selectedSize != null ? _sizeOptions[_selectedSize]! : 0,
      specialInstructions: _specialInstructions.isNotEmpty
          ? _specialInstructions
          : null,
      addedAt: DateTime.now(),
    );

    // Check if cart has items from different supplier
    final cartBloc = context.read<CartBloc>();
    final cartSupplierId = cartBloc.getCartSupplierId();

    debugPrint('Cart Supplier ID: $cartSupplierId');
    debugPrint('Item Supplier ID: ${widget.item.supplierId}');
    debugPrint('Cart State: ${cartBloc.state}');

    if (cartSupplierId != null && cartSupplierId != widget.item.supplierId) {
      debugPrint('Different supplier detected! Showing dialog...');
      // Show dialog to confirm replacing cart
      final shouldReplace = await showDialog<bool>(
        context: context,
        builder: (context) => ReplaceCartDialog(
          currentSupplierName: 'Supplier #$cartSupplierId',
          newSupplierName: 'Supplier #${widget.item.supplierId}',
        ),
      );

      if (shouldReplace == true) {
        // Replace cart and add new item
        cartBloc.add(ReplaceCartAndAddEvent(cartItem));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.cartReplaced),
              duration: const Duration(seconds: 2),
              backgroundColor: context.cs.primary,
            ),
          );
          Navigator.pop(context);
        }
      }
      // If user cancels, do nothing
      return;
    }

    // Add to cart via BLoC (same supplier or empty cart)
    cartBloc.add(AddToCartEvent(cartItem));

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.itemAddedToCart),
          duration: const Duration(seconds: 2),
          backgroundColor: context.cs.primary,
        ),
      );

      Navigator.pop(context);
    }
  }
}
