import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';

/// Remote data source for item data (mock implementation).
abstract class ItemRemoteDataSource {
  /// Get items for a specific supplier.
  Future<List<Item>> getItemsBySupplierId(int supplierId);

  /// Get a single item by ID.
  Future<Item> getItemById(int id);

  /// Get featured items for a supplier.
  Future<List<Item>> getFeaturedItemsBySupplierId(int supplierId);
}

/// Mock implementation of [ItemRemoteDataSource] with fake data.
class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  // Mock data - Food Fort items (Supplier ID: 1)
  static final List<Item> _foodFortItems = [
    // Burgers
    Item(
      id: 1,
      supplierId: 1,
      categoryId: 1,
      name: 'Cheese Burger',
      description:
          'Juicy beef patty with melted cheese, fresh lettuce, tomato, pickles, and special sauce on a toasted bun.',
      shortDescription: 'Beef patty with melted cheese',
      price: 7000,
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 580,
        'spiciness': 0,
        'allergens': ['dairy', 'gluten'],
      },
      prepTimeMinutes: 15,
      status: ItemStatus.available,
      imageURL: 'assets/images/food/food1.png',
      rating: 4.6,
      reviewCount: 234,
    ),
    Item(
      id: 2,
      supplierId: 1,
      categoryId: 1,
      name: 'Classic Burger',
      description:
          'Premium beef patty grilled to perfection with classic toppings and our signature sauce. Old school taste.',
      shortDescription: 'Premium beef with classic toppings',
      price: 6000,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 520,
        'spiciness': 0,
        'allergens': ['gluten'],
      },
      prepTimeMinutes: 12,
      status: ItemStatus.available,
      imageURL: 'assets/images/food/food1.png',
      rating: 4.6,
      reviewCount: 189,
    ),
    Item(
      id: 3,
      supplierId: 1,
      categoryId: 1,
      name: 'Tasty Burger',
      description:
          'Double beef patty with extra cheese, caramelized onions, bacon, and BBQ sauce. Maximum flavor!',
      shortDescription: 'Double patty with bacon and BBQ',
      price: 8000,
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 720,
        'spiciness': 1,
        'allergens': ['dairy', 'gluten', 'pork'],
      },
      prepTimeMinutes: 18,
      status: ItemStatus.available,
      imageURL: 'assets/images/food/food1.png',
      rating: 4.6,
      reviewCount: 312,
    ),
    // Pizza
    Item(
      id: 4,
      supplierId: 1,
      categoryId: 2,
      name: 'Vegetable Pizza',
      description:
          'Fresh vegetables including bell peppers, mushrooms, olives, onions on tomato sauce with mozzarella.',
      shortDescription: 'Fresh veggies with mozzarella',
      price: 15000,
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      freeDelivery: true,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 850,
        'spiciness': 0,
        'allergens': ['dairy', 'gluten'],
        'vegetarian': true,
      },
      prepTimeMinutes: 25,
      status: ItemStatus.available,
      isFeaturedUntil: DateTime.now().add(const Duration(days: 7)),
      imageURL: 'assets/images/food/food1.png',
      rating: 4.7,
      reviewCount: 156,
    ),
    // Salads
    Item(
      id: 5,
      supplierId: 1,
      categoryId: 3,
      name: 'Salads',
      description:
          'Fresh mixed greens with cherry tomatoes, cucumbers, carrots, and your choice of dressing.',
      shortDescription: 'Fresh mixed greens salad',
      price: 7000,
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 180,
        'spiciness': 0,
        'allergens': [],
        'vegetarian': true,
        'vegan': true,
      },
      prepTimeMinutes: 8,
      status: ItemStatus.available,
      isFeaturedUntil: DateTime.now().add(const Duration(days: 3)),
      imageURL: 'assets/images/food/food1.png',
      rating: 4.5,
      reviewCount: 98,
    ),
    Item(
      id: 6,
      supplierId: 1,
      categoryId: 3,
      name: 'Salads',
      description:
          'Grilled chicken breast on romaine lettuce with parmesan cheese, croutons, and Caesar dressing.',
      shortDescription: 'Chicken with Caesar dressing',
      price: 9000,
      updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 420,
        'spiciness': 0,
        'allergens': ['dairy', 'gluten', 'egg'],
      },
      prepTimeMinutes: 12,
      status: ItemStatus.available,
      isFeaturedUntil: DateTime.now().add(const Duration(days: 5)),
      imageURL: 'assets/images/food/food1.png',
      rating: 4.8,
      reviewCount: 145,
    ),
    // Sides
    Item(
      id: 7,
      supplierId: 1,
      categoryId: null,
      name: 'French Fries',
      description: 'Crispy golden french fries seasoned with sea salt.',
      shortDescription: 'Crispy golden fries',
      price: 3000,
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.side,
      metadata: {'calories': 320, 'spiciness': 0, 'allergens': []},
      prepTimeMinutes: 8,
      status: ItemStatus.available,
      imageURL: 'assets/images/food/food1.png',
      rating: 4.4,
      reviewCount: 210,
    ),
    // Drinks
    Item(
      id: 8,
      supplierId: 1,
      categoryId: null,
      name: 'Coca Cola',
      description: 'Refreshing Coca Cola - 330ml can',
      shortDescription: 'Classic Coke',
      price: 1500,
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.drink,
      metadata: {'calories': 140, 'size': '330ml'},
      prepTimeMinutes: 2,
      status: ItemStatus.available,
      imageURL: 'assets/images/food/food1.png',
      rating: 4.3,
      reviewCount: 89,
    ),
  ];

  // Mock data - Turath items (Supplier ID: 2)
  static final List<Item> _turathItems = [
    Item(
      id: 101,
      supplierId: 2,
      categoryId: 10,
      name: 'Masgouf',
      description:
          'Traditional Iraqi grilled fish marinated with special spices and grilled over open flames.',
      shortDescription: 'Traditional grilled fish',
      price: 25000,
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      freeDelivery: true,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {
        'calories': 450,
        'spiciness': 2,
        'allergens': ['fish'],
        'traditional': true,
      },
      prepTimeMinutes: 35,
      status: ItemStatus.available,
      isFeaturedUntil: DateTime.now().add(const Duration(days: 10)),
      imageURL: 'assets/images/food/food1.png',
      rating: 4.9,
      reviewCount: 456,
    ),
    Item(
      id: 102,
      supplierId: 2,
      categoryId: 10,
      name: 'Kabab',
      description:
          'Grilled minced meat kebab with traditional Iraqi spices, served with rice and vegetables.',
      shortDescription: 'Iraqi grilled kebab',
      price: 12000,
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      freeDelivery: false,
      isVisible: true,
      isAvailable: true,
      type: ItemType.food,
      metadata: {'calories': 520, 'spiciness': 2, 'allergens': []},
      prepTimeMinutes: 20,
      status: ItemStatus.available,
      imageURL: 'assets/images/food/food1.png',
      rating: 4.7,
      reviewCount: 289,
    ),
  ];

  // All items combined
  static final Map<int, List<Item>> _itemsBySupplierId = {
    1: _foodFortItems,
    2: _turathItems,
    3: [], // Arido - can add items later
    4: [], // Pizza House
    5: [], // Sushi Master
  };

  @override
  Future<List<Item>> getItemsBySupplierId(int supplierId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _itemsBySupplierId[supplierId] ?? [];
  }

  @override
  Future<Item> getItemById(int id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    for (var items in _itemsBySupplierId.values) {
      try {
        return items.firstWhere((item) => item.id == id);
      } catch (e) {
        continue;
      }
    }

    throw Exception('Item not found');
  }

  @override
  Future<List<Item>> getFeaturedItemsBySupplierId(int supplierId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final items = _itemsBySupplierId[supplierId] ?? [];
    return items.where((item) => item.isFeatured).toList();
  }
}
