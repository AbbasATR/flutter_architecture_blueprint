import 'package:equatable/equatable.dart';

enum OrderStatus {
  ordered,
  processing,
  readyForPickup,
  onTheWay,
  delivered,
  canceled,
}

enum PaymentMethod { cashOnDelivery, card, wallet }

enum CancelReason {
  customerRequest,
  supplierUnavailable,
  itemsUnavailable,
  addressIssue,
  paymentIssue,
  other,
}

class Order extends Equatable {
  final int id;
  final DateTime timestamp;
  final int orderedById;
  final int? driverId;
  final int? managedById;
  final OrderStatus status;
  final String? freeDeliveryQualifier;
  final double cashPaid;
  final int pointsPaid;
  final bool isSettled;
  final String? clientNotes;
  final String identifier;
  final PaymentMethod paymentMethod;
  final double subtotalAmount;
  final double discountTotal;
  final double deliveryFee;
  final int prepMinutes;
  final String? supplierNotes;
  final CancelReason? cancelReason;
  final DateTime? confirmedAt;
  final DateTime? pickedUpAt;
  final DateTime? preparedAt;
  final DateTime? canceledAt;
  final DateTime? deliveredAt;
  final String? dropoffLatLong;
  final String dropoffAddress;
  final String supplierName;
  final String? supplierImage;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.timestamp,
    required this.orderedById,
    this.driverId,
    this.managedById,
    required this.status,
    this.freeDeliveryQualifier,
    required this.cashPaid,
    required this.pointsPaid,
    required this.isSettled,
    this.clientNotes,
    required this.identifier,
    required this.paymentMethod,
    required this.subtotalAmount,
    required this.discountTotal,
    required this.deliveryFee,
    required this.prepMinutes,
    this.supplierNotes,
    this.cancelReason,
    this.confirmedAt,
    this.pickedUpAt,
    this.preparedAt,
    this.canceledAt,
    this.deliveredAt,
    this.dropoffLatLong,
    required this.dropoffAddress,
    required this.supplierName,
    this.supplierImage,
    required this.items,
  });

  double get totalAmount => subtotalAmount - discountTotal + deliveryFee;

  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.canceled;

  @override
  List<Object?> get props => [
    id,
    timestamp,
    orderedById,
    driverId,
    managedById,
    status,
    freeDeliveryQualifier,
    cashPaid,
    pointsPaid,
    isSettled,
    clientNotes,
    identifier,
    paymentMethod,
    subtotalAmount,
    discountTotal,
    deliveryFee,
    prepMinutes,
    supplierNotes,
    cancelReason,
    confirmedAt,
    pickedUpAt,
    preparedAt,
    canceledAt,
    deliveredAt,
    dropoffLatLong,
    dropoffAddress,
    supplierName,
    supplierImage,
    items,
  ];
}

class OrderItem extends Equatable {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [name, quantity, price];
}
