import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';

/// Remote data source for search operations
abstract class SearchRemoteDataSource {
  Future<List<SearchItem>> searchItems(String query);
  Future<List<SearchSupplier>> searchSuppliers(String query);
}

/// Implementation with mock data for testing
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  @override
  Future<List<SearchItem>> searchItems(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API call
    final allItems = [
      const SearchItem(
        id: '1',
        name: 'Beef Burger',
        description: 'Delicious beef burger with cheese',
        imageUrl: 'https://via.placeholder.com/150',
        price: 12.99,
        supplierId: 'sup1',
        supplierName: 'Burger House',
        category: 'Fast Food',
        rating: 4.5,
      ),
      const SearchItem(
        id: '2',
        name: 'Margherita Pizza',
        description: 'Classic Italian pizza',
        imageUrl: 'https://via.placeholder.com/150',
        price: 15.99,
        supplierId: 'sup2',
        supplierName: 'Pizza Palace',
        category: 'Italian',
        rating: 4.8,
      ),
      const SearchItem(
        id: '3',
        name: 'Caesar Salad',
        description: 'Fresh caesar salad with chicken',
        imageUrl: 'https://via.placeholder.com/150',
        price: 9.99,
        supplierId: 'sup3',
        supplierName: 'Healthy Bites',
        category: 'Salads',
        rating: 4.3,
      ),
      const SearchItem(
        id: '4',
        name: 'Chicken Wings',
        description: 'Spicy chicken wings',
        imageUrl: 'https://via.placeholder.com/150',
        price: 8.99,
        supplierId: 'sup1',
        supplierName: 'Burger House',
        category: 'Fast Food',
        rating: 4.6,
      ),
      const SearchItem(
        id: '5',
        name: 'Sushi Roll',
        description: 'Fresh sushi rolls',
        imageUrl: 'https://via.placeholder.com/150',
        price: 18.99,
        supplierId: 'sup4',
        supplierName: 'Sushi Master',
        category: 'Japanese',
        rating: 4.9,
      ),
    ];

    // Filter items based on query
    return allItems
        .where(
          (item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.category.toLowerCase().contains(query.toLowerCase()) ||
              item.supplierName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<List<SearchSupplier>> searchSuppliers(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API call
    final allSuppliers = [
      const SearchSupplier(
        id: 'sup1',
        name: 'Burger House',
        description: 'Best burgers in town',
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Fast Food',
        rating: 4.5,
        reviewCount: 250,
        deliveryTime: '20-30 min',
        deliveryFee: 2.99,
      ),
      const SearchSupplier(
        id: 'sup2',
        name: 'Pizza Palace',
        description: 'Authentic Italian pizza',
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Italian',
        rating: 4.8,
        reviewCount: 500,
        deliveryTime: '25-35 min',
        deliveryFee: 3.99,
      ),
      const SearchSupplier(
        id: 'sup3',
        name: 'Healthy Bites',
        description: 'Fresh and healthy food',
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Healthy',
        rating: 4.3,
        reviewCount: 180,
        deliveryTime: '15-25 min',
        deliveryFee: 1.99,
      ),
      const SearchSupplier(
        id: 'sup4',
        name: 'Sushi Master',
        description: 'Premium Japanese cuisine',
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Japanese',
        rating: 4.9,
        reviewCount: 800,
        deliveryTime: '30-40 min',
        deliveryFee: 4.99,
      ),
      const SearchSupplier(
        id: 'sup5',
        name: 'Taco Fiesta',
        description: 'Authentic Mexican tacos',
        imageUrl: 'https://via.placeholder.com/150',
        category: 'Mexican',
        rating: 4.6,
        reviewCount: 320,
        deliveryTime: '20-30 min',
        deliveryFee: 2.49,
      ),
    ];

    // Filter suppliers based on query
    return allSuppliers
        .where(
          (supplier) =>
              supplier.name.toLowerCase().contains(query.toLowerCase()) ||
              supplier.category.toLowerCase().contains(query.toLowerCase()) ||
              supplier.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
