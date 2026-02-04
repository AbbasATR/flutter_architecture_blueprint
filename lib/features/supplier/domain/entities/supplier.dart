import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_state.dart';

/// Entity representing a supplier/vendor in the system.
class Supplier extends Equatable {
  /// Unique identifier for the supplier
  final int id;

  /// Name of the supplier
  final String name;

  /// Slogan or tagline of the supplier
  final String slogan;

  /// Current operational state of the supplier
  final SupplierState state;

  /// Geographic coordinates (latitude,longitude)
  final String latLong;

  /// Type of business
  final SupplierBusinessType businessType;

  /// URL to the supplier's logo image
  final String logoURL;

  /// URL to the supplier's banner image
  final String bannerURL;

  /// Human-readable address description
  final String addressDescription;

  /// Minimum order amount required
  final double minOrderAmount;

  /// Base delivery fee
  final double deliveryFeeBase;

  /// Operating information (hours, policies, etc.) stored as dynamic JSON
  /// Structure can be designed based on requirements
  final Map<String, dynamic> operatingInfo;

  /// Whether the supplier is currently closed (overrides operating hours)
  final bool isClosed;

  /// Average rating (0-5)
  final double rating;

  /// Number of reviews
  final int reviewCount;

  /// Estimated delivery time in minutes
  final int deliveryTimeMin;

  const Supplier({
    required this.id,
    required this.name,
    required this.slogan,
    required this.state,
    required this.latLong,
    required this.businessType,
    required this.logoURL,
    required this.bannerURL,
    required this.addressDescription,
    required this.minOrderAmount,
    required this.deliveryFeeBase,
    required this.operatingInfo,
    this.isClosed = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.deliveryTimeMin = 30,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slogan,
    state,
    latLong,
    businessType,
    logoURL,
    bannerURL,
    addressDescription,
    minOrderAmount,
    deliveryFeeBase,
    operatingInfo,
    isClosed,
    rating,
    reviewCount,
    deliveryTimeMin,
  ];
}
