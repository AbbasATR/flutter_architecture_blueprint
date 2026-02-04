import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_state.dart';

/// Remote data source for supplier data (mock implementation).
abstract class SupplierRemoteDataSource {
  /// Get suppliers filtered by business type.
  Future<List<Supplier>> getSuppliersByBusinessType(
    SupplierBusinessType businessType,
  );

  /// Get a single supplier by ID.
  Future<Supplier> getSupplierById(int id);

  /// Get all suppliers.
  Future<List<Supplier>> getAllSuppliers();
}

/// Mock implementation of [SupplierRemoteDataSource] with fake data.
class SupplierRemoteDataSourceImpl implements SupplierRemoteDataSource {
  // Mock data - Restaurants
  static final List<Supplier> _mockRestaurants = [
    Supplier(
      id: 1,
      name: 'Food Fort - Karbala',
      slogan: 'Delicious burgers and fast food',
      state: SupplierState.active,
      latLong: '32.6150,44.0245',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'https://i.pravatar.cc/150?img=1',
      bannerURL: 'assets/images/atr_restaurants/food_fort.png',
      addressDescription: 'Al-Hussein City, Karbala',
      minOrderAmount: 5000,
      deliveryFeeBase: 2000,
      rating: 4.8,
      reviewCount: 2500,
      deliveryTimeMin: 32,
      operatingInfo: {
        'openingHours': '10:00 AM - 11:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Best burgers in town',
      },
      isClosed: false,
    ),
    Supplier(
      id: 2,
      name: 'Turath - Karbala',
      slogan: 'Traditional Iraqi cuisine',
      state: SupplierState.active,
      latLong: '32.6200,44.0300',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'https://i.pravatar.cc/150?img=2',
      bannerURL: 'assets/images/atr_restaurants/turath_banner.jpg',
      addressDescription: 'Al-Mukhayam, Karbala',
      minOrderAmount: 10000,
      deliveryFeeBase: 1000,
      rating: 4.8,
      reviewCount: 1800,
      deliveryTimeMin: 42,
      operatingInfo: {
        'openingHours': '11:00 AM - 12:00 AM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Authentic Iraqi dishes',
      },
      isClosed: false,
    ),
    Supplier(
      id: 3,
      name: 'Arido - Karbala',
      slogan: 'Healthy and delicious meals',
      state: SupplierState.active,
      latLong: '32.6100,44.0350',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'https://i.pravatar.cc/150?img=3',
      bannerURL: 'assets/images/atr_restaurants/arido_banner.jpg',
      addressDescription: 'Al-Abbas Street, Karbala',
      minOrderAmount: 7500,
      deliveryFeeBase: 1500,
      rating: 4.8,
      reviewCount: 3200,
      deliveryTimeMin: 38,
      operatingInfo: {
        'openingHours': '9:00 AM - 10:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Fresh ingredients daily',
      },
      isClosed: false,
    ),
    Supplier(
      id: 4,
      name: 'Pizza House - Karbala',
      slogan: 'Wood-fired pizza perfection',
      state: SupplierState.active,
      latLong: '32.6180,44.0280',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'https://i.pravatar.cc/150?img=4',
      bannerURL: 'assets/images/food/pizza.png',
      addressDescription: 'Al-Hussein City, Karbala',
      minOrderAmount: 15000,
      deliveryFeeBase: 2500,
      rating: 4.7,
      reviewCount: 1500,
      deliveryTimeMin: 35,
      operatingInfo: {
        'openingHours': '12:00 PM - 11:30 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Italian style pizza',
      },
      isClosed: false,
    ),
    Supplier(
      id: 5,
      name: 'Sushi Master - Karbala',
      slogan: 'Fresh sushi daily',
      state: SupplierState.active,
      latLong: '32.6220,44.0320',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'https://i.pravatar.cc/150?img=5',
      bannerURL: 'assets/images/food/sushi.png',
      addressDescription: 'Al-Mukhayam, Karbala',
      minOrderAmount: 20000,
      deliveryFeeBase: 3000,
      rating: 4.9,
      reviewCount: 980,
      deliveryTimeMin: 45,
      operatingInfo: {
        'openingHours': '1:00 PM - 11:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Premium Japanese cuisine',
      },
      isClosed: false,
    ),
  ];

  // Mock data - Shopping
  static final List<Supplier> _mockShopping = [
    Supplier(
      id: 101,
      name: 'Fashion Hub - Karbala',
      slogan: 'Latest trends, best prices',
      state: SupplierState.active,
      latLong: '32.6170,44.0260',
      businessType: SupplierBusinessType.shopping,
      logoURL: 'https://i.pravatar.cc/150?img=11',
      bannerURL: 'assets/images/categories/fashion.png',
      addressDescription: 'Al-Hussein City, Karbala',
      minOrderAmount: 25000,
      deliveryFeeBase: 3000,
      rating: 4.6,
      reviewCount: 1200,
      deliveryTimeMin: 60,
      operatingInfo: {
        'openingHours': '9:00 AM - 9:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Free returns within 7 days',
      },
      isClosed: false,
    ),
    Supplier(
      id: 102,
      name: 'Electronics World',
      slogan: 'Tech at your fingertips',
      state: SupplierState.active,
      latLong: '32.6190,44.0290',
      businessType: SupplierBusinessType.shopping,
      logoURL: 'https://i.pravatar.cc/150?img=12',
      bannerURL: 'assets/images/categories/electronics.png',
      addressDescription: 'Al-Mukhayam, Karbala',
      minOrderAmount: 50000,
      deliveryFeeBase: 5000,
      rating: 4.7,
      reviewCount: 850,
      deliveryTimeMin: 90,
      operatingInfo: {
        'openingHours': '10:00 AM - 10:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': '1 year warranty on all products',
      },
      isClosed: false,
    ),
    Supplier(
      id: 103,
      name: 'Home Essentials',
      slogan: 'Everything for your home',
      state: SupplierState.active,
      latLong: '32.6140,44.0240',
      businessType: SupplierBusinessType.shopping,
      logoURL: 'https://i.pravatar.cc/150?img=13',
      bannerURL: 'assets/images/categories/home.png',
      addressDescription: 'Al-Abbas Street, Karbala',
      minOrderAmount: 30000,
      deliveryFeeBase: 4000,
      rating: 4.5,
      reviewCount: 670,
      deliveryTimeMin: 75,
      operatingInfo: {
        'openingHours': '8:00 AM - 8:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Installation service available',
      },
      isClosed: false,
    ),
  ];

  // Mock data - Grocery
  static final List<Supplier> _mockGrocery = [
    Supplier(
      id: 201,
      name: 'Fresh Market - Karbala',
      slogan: 'Farm fresh every day',
      state: SupplierState.active,
      latLong: '32.6160,44.0270',
      businessType: SupplierBusinessType.grocery,
      logoURL: 'https://i.pravatar.cc/150?img=21',
      bannerURL: 'assets/images/categories/vegetables.png',
      addressDescription: 'Al-Hussein City, Karbala',
      minOrderAmount: 10000,
      deliveryFeeBase: 2000,
      rating: 4.6,
      reviewCount: 2100,
      deliveryTimeMin: 30,
      operatingInfo: {
        'openingHours': '7:00 AM - 10:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Fresh produce delivered daily',
      },
      isClosed: false,
    ),
    Supplier(
      id: 202,
      name: 'Super Store Karbala',
      slogan: 'One stop for all groceries',
      state: SupplierState.active,
      latLong: '32.6210,44.0310',
      businessType: SupplierBusinessType.grocery,
      logoURL: 'https://i.pravatar.cc/150?img=22',
      bannerURL: 'assets/images/categories/grocery.png',
      addressDescription: 'Al-Mukhayam, Karbala',
      minOrderAmount: 15000,
      deliveryFeeBase: 2500,
      rating: 4.7,
      reviewCount: 3500,
      deliveryTimeMin: 40,
      operatingInfo: {
        'openingHours': '6:00 AM - 11:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Wide variety of products',
      },
      isClosed: false,
    ),
    Supplier(
      id: 203,
      name: 'Organic Bites',
      slogan: 'Healthy living starts here',
      state: SupplierState.active,
      latLong: '32.6130,44.0250',
      businessType: SupplierBusinessType.grocery,
      logoURL: 'https://i.pravatar.cc/150?img=23',
      bannerURL: 'assets/images/categories/fruits.png',
      addressDescription: 'Al-Abbas Street, Karbala',
      minOrderAmount: 20000,
      deliveryFeeBase: 3000,
      rating: 4.8,
      reviewCount: 1250,
      deliveryTimeMin: 35,
      operatingInfo: {
        'openingHours': '8:00 AM - 9:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': '100% organic certified products',
      },
      isClosed: false,
    ),
  ];

  // Mock data - Flowers
  static final List<Supplier> _mockFlowers = [
    Supplier(
      id: 301,
      name: 'Rose Garden - Karbala',
      slogan: 'Fresh flowers for every occasion',
      state: SupplierState.active,
      latLong: '32.6150,44.0265',
      businessType: SupplierBusinessType.flowers,
      logoURL: 'https://i.pravatar.cc/150?img=31',
      bannerURL: 'assets/images/categories/flowers.png',
      addressDescription: 'Al-Hussein City, Karbala',
      minOrderAmount: 15000,
      deliveryFeeBase: 2000,
      rating: 4.9,
      reviewCount: 780,
      deliveryTimeMin: 45,
      operatingInfo: {
        'openingHours': '8:00 AM - 8:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Same day delivery available',
      },
      isClosed: false,
    ),
    Supplier(
      id: 302,
      name: 'Bloom Boutique',
      slogan: 'Artisan floral arrangements',
      state: SupplierState.active,
      latLong: '32.6195,44.0295',
      businessType: SupplierBusinessType.flowers,
      logoURL: 'https://i.pravatar.cc/150?img=32',
      bannerURL: 'assets/images/categories/flowers.png',
      addressDescription: 'Al-Mukhayam, Karbala',
      minOrderAmount: 20000,
      deliveryFeeBase: 2500,
      rating: 4.8,
      reviewCount: 540,
      deliveryTimeMin: 50,
      operatingInfo: {
        'openingHours': '9:00 AM - 7:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Custom bouquets on request',
      },
      isClosed: false,
    ),
    Supplier(
      id: 303,
      name: 'Petals & More',
      slogan: 'Express your feelings with flowers',
      state: SupplierState.active,
      latLong: '32.6175,44.0275',
      businessType: SupplierBusinessType.flowers,
      logoURL: 'https://i.pravatar.cc/150?img=33',
      bannerURL: 'assets/images/categories/flowers.png',
      addressDescription: 'Al-Abbas Street, Karbala',
      minOrderAmount: 12000,
      deliveryFeeBase: 1500,
      rating: 4.7,
      reviewCount: 620,
      deliveryTimeMin: 40,
      operatingInfo: {
        'openingHours': '7:00 AM - 9:00 PM',
        'daysOpen': [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'specialNotes': 'Wedding and event specialists',
      },
      isClosed: false,
    ),
  ];

  // All suppliers combined
  static final List<Supplier> _allSuppliers = [
    ..._mockRestaurants,
    ..._mockShopping,
    ..._mockGrocery,
    ..._mockFlowers,
  ];

  @override
  Future<List<Supplier>> getSuppliersByBusinessType(
    SupplierBusinessType businessType,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    switch (businessType) {
      case SupplierBusinessType.restaurant:
        return _mockRestaurants;
      case SupplierBusinessType.shopping:
        return _mockShopping;
      case SupplierBusinessType.grocery:
        return _mockGrocery;
      case SupplierBusinessType.flowers:
        return _mockFlowers;
      default:
        return [];
    }
  }

  @override
  Future<Supplier> getSupplierById(int id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _allSuppliers.firstWhere((supplier) => supplier.id == id);
    } catch (e) {
      throw Exception('Supplier not found');
    }
  }

  @override
  Future<List<Supplier>> getAllSuppliers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _allSuppliers;
  }
}
