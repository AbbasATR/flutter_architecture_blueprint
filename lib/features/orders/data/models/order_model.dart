import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.timestamp,
    required super.orderedById,
    super.driverId,
    super.managedById,
    required super.status,
    super.freeDeliveryQualifier,
    required super.cashPaid,
    required super.pointsPaid,
    required super.isSettled,
    super.clientNotes,
    required super.identifier,
    required super.paymentMethod,
    required super.subtotalAmount,
    required super.discountTotal,
    required super.deliveryFee,
    required super.prepMinutes,
    super.supplierNotes,
    super.cancelReason,
    super.confirmedAt,
    super.pickedUpAt,
    super.preparedAt,
    super.canceledAt,
    super.deliveredAt,
    super.dropoffLatLong,
    required super.dropoffAddress,
    required super.supplierName,
    super.supplierImage,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      orderedById: json['ordered_by_id'] as int,
      driverId: json['driver_id'] as int?,
      managedById: json['managed_by_id'] as int?,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.ordered,
      ),
      freeDeliveryQualifier: json['free_delivery_qualifier'] as String?,
      cashPaid: (json['cash_paid'] as num).toDouble(),
      pointsPaid: json['points_paid'] as int,
      isSettled: json['is_settled'] as bool,
      clientNotes: json['client_notes'] as String?,
      identifier: json['identifier'] as String,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['payment_method'],
        orElse: () => PaymentMethod.cashOnDelivery,
      ),
      subtotalAmount: (json['subtotal_amount'] as num).toDouble(),
      discountTotal: (json['discount_total'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      prepMinutes: json['prep_minutes'] as int,
      supplierNotes: json['supplier_notes'] as String?,
      cancelReason: json['cancel_reason'] != null
          ? CancelReason.values.firstWhere(
              (e) => e.name == json['cancel_reason'],
              orElse: () => CancelReason.other,
            )
          : null,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      pickedUpAt: json['picked_up_at'] != null
          ? DateTime.parse(json['picked_up_at'] as String)
          : null,
      preparedAt: json['prepared_at'] != null
          ? DateTime.parse(json['prepared_at'] as String)
          : null,
      canceledAt: json['canceled_at'] != null
          ? DateTime.parse(json['canceled_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      dropoffLatLong: json['dropoff_lat_long'] as String?,
      dropoffAddress: json['dropoff_address'] as String,
      supplierName: json['supplier_name'] as String,
      supplierImage: json['supplier_image'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  factory OrderModel.fromCreateOrder({
    required List<OrderItemModel> items,
    required String deliveryAddress,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double deliveryFee,
    String? notes,
  }) {
    final now = DateTime.now().toUtc();
    final total = subtotal + deliveryFee;

    return OrderModel(
      id: now.millisecondsSinceEpoch,
      timestamp: now,
      orderedById: 0,
      status: OrderStatus.ordered,
      cashPaid: paymentMethod == PaymentMethod.cashOnDelivery ? total : 0,
      pointsPaid: 0,
      isSettled: paymentMethod != PaymentMethod.cashOnDelivery,
      clientNotes: notes,
      identifier: 'ORD-${now.millisecondsSinceEpoch}',
      paymentMethod: paymentMethod,
      subtotalAmount: subtotal,
      discountTotal: 0,
      deliveryFee: deliveryFee,
      prepMinutes: 30,
      dropoffAddress: deliveryAddress,
      supplierName: items.isNotEmpty ? items.first.name : 'Unknown Supplier',
      items: items,
    );
  }

  Order toEntity() => Order(
    id: id,
    timestamp: timestamp,
    orderedById: orderedById,
    driverId: driverId,
    managedById: managedById,
    status: status,
    freeDeliveryQualifier: freeDeliveryQualifier,
    cashPaid: cashPaid,
    pointsPaid: pointsPaid,
    isSettled: isSettled,
    clientNotes: clientNotes,
    identifier: identifier,
    paymentMethod: paymentMethod,
    subtotalAmount: subtotalAmount,
    discountTotal: discountTotal,
    deliveryFee: deliveryFee,
    prepMinutes: prepMinutes,
    supplierNotes: supplierNotes,
    cancelReason: cancelReason,
    confirmedAt: confirmedAt,
    pickedUpAt: pickedUpAt,
    preparedAt: preparedAt,
    canceledAt: canceledAt,
    deliveredAt: deliveredAt,
    dropoffLatLong: dropoffLatLong,
    dropoffAddress: dropoffAddress,
    supplierName: supplierName,
    supplierImage: supplierImage,
    items: items,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'ordered_by_id': orderedById,
      'driver_id': driverId,
      'managed_by_id': managedById,
      'status': status.name,
      'free_delivery_qualifier': freeDeliveryQualifier,
      'cash_paid': cashPaid,
      'points_paid': pointsPaid,
      'is_settled': isSettled,
      'client_notes': clientNotes,
      'identifier': identifier,
      'payment_method': paymentMethod.name,
      'subtotal_amount': subtotalAmount,
      'discount_total': discountTotal,
      'delivery_fee': deliveryFee,
      'prep_minutes': prepMinutes,
      'supplier_notes': supplierNotes,
      'cancel_reason': cancelReason?.name,
      'confirmed_at': confirmedAt?.toIso8601String(),
      'picked_up_at': pickedUpAt?.toIso8601String(),
      'prepared_at': preparedAt?.toIso8601String(),
      'canceled_at': canceledAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'dropoff_lat_long': dropoffLatLong,
      'dropoff_address': dropoffAddress,
      'supplier_name': supplierName,
      'supplier_image': supplierImage,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
    };
  }
}

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.name,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      name: entity.name,
      quantity: entity.quantity,
      price: entity.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'price': price};
  }
}
