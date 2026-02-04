import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_architecture_blueprint/features/cart/data/models/cart_item_model.dart';

/// Local data source for cart operations using shared_preferences
abstract class CartLocalDataSource {
  /// Get all cart items
  Future<List<CartItemModel>> getCartItems();

  /// Add item to cart
  Future<void> addCartItem(CartItemModel item);

  /// Update cart item
  Future<void> updateCartItem(CartItemModel item);

  /// Delete cart item by id
  Future<void> deleteCartItem(String id);

  /// Clear all cart items
  Future<void> clearCart();

  /// Get cart item by id
  Future<CartItemModel?> getCartItemById(String id);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _cartKey = 'cart_items';
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final jsonString = sharedPreferences.getString(_cartKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  @override
  Future<void> addCartItem(CartItemModel item) async {
    final items = await getCartItems();

    // Check if item already exists (same item and size)
    final existingIndex = items.indexWhere(
      (cartItem) =>
          cartItem.item.id == item.item.id &&
          cartItem.selectedSize == item.selectedSize,
    );

    if (existingIndex != -1) {
      // Update quantity if item exists
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + item.quantity,
      );
    } else {
      // Add new item
      items.add(item);
    }

    await _saveCartItems(items);
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    final items = await getCartItems();
    final index = items.indexWhere((cartItem) => cartItem.id == item.id);

    if (index != -1) {
      items[index] = item;
      await _saveCartItems(items);
    }
  }

  @override
  Future<void> deleteCartItem(String id) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.id == id);
    await _saveCartItems(items);
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(_cartKey);
  }

  @override
  Future<CartItemModel?> getCartItemById(String id) async {
    final items = await getCartItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveCartItems(List<CartItemModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(_cartKey, jsonString);
  }
}
