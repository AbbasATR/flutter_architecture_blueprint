import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/create_order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_active_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_past_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';

class MockGetActiveOrders extends Mock implements GetActiveOrders {}
class MockGetPastOrders extends Mock implements GetPastOrders {}
class MockCreateOrder extends Mock implements CreateOrder {}

void main() {
  late OrderBloc orderBloc;
  late MockGetActiveOrders mockGetActiveOrders;
  late MockGetPastOrders mockGetPastOrders;
  late MockCreateOrder mockCreateOrder;

  setUp(() {
    mockGetActiveOrders = MockGetActiveOrders();
    mockGetPastOrders = MockGetPastOrders();
    mockCreateOrder = MockCreateOrder();
    orderBloc = OrderBloc(
      getActiveOrders: mockGetActiveOrders,
      getPastOrders: mockGetPastOrders,
      createOrder: mockCreateOrder,
    );
  });

  tearDown(() => orderBloc.close());

  final tActiveOrders = [Order(id: 1, timestamp: DateTime(2024, 1, 1), orderedById: 1, status: OrderStatus.processing, cashPaid: 50.0, pointsPaid: 0, isSettled: false, identifier: 'ORD-001', paymentMethod: PaymentMethod.cashOnDelivery, subtotalAmount: 40.0, discountTotal: 0.0, deliveryFee: 10.0, prepMinutes: 30, dropoffAddress: '123 Main St', supplierName: 'Test Restaurant', items: const [OrderItem(name: 'Pizza', quantity: 2, price: 20.0)])];
  final tPastOrders = [Order(id: 2, timestamp: DateTime(2023, 12, 1), orderedById: 1, status: OrderStatus.delivered, cashPaid: 30.0, pointsPaid: 0, isSettled: true, identifier: 'ORD-002', paymentMethod: PaymentMethod.card, subtotalAmount: 25.0, discountTotal: 0.0, deliveryFee: 5.0, prepMinutes: 20, dropoffAddress: '456 Oak Ave', supplierName: 'Burger Place', items: const [OrderItem(name: 'Burger', quantity: 1, price: 25.0)], deliveredAt: DateTime(2023, 12, 1, 14, 30))];
  final tItem = Item(id: 1, name: 'Test Item', shortDescription: 'Short desc', description: 'Full description', imageURL: 'test.jpg', price: 20.0, categoryId: 1, supplierId: 1, isAvailable: true, rating: 4.5, reviewCount: 10, updatedAt: DateTime(2024, 1, 1), type: ItemType.food, metadata: const {}, prepTimeMinutes: 30, status: ItemStatus.available);
  late List<CartItem> tCartItems;
  late Order tNewOrder;
  setUp(() {
    tCartItems = [CartItem(id: '1', item: tItem, quantity: 2, sizePrice: 0.0, addedAt: DateTime(2024, 1, 1))];
    tNewOrder = Order(id: 3, timestamp: DateTime(2024, 1, 2), orderedById: 1, status: OrderStatus.ordered, cashPaid: 45.0, pointsPaid: 0, isSettled: false, identifier: 'ORD-003', paymentMethod: PaymentMethod.cashOnDelivery, subtotalAmount: 40.0, discountTotal: 0.0, deliveryFee: 5.0, prepMinutes: 25, dropoffAddress: '789 Elm St', supplierName: 'Pizza Place', items: const [OrderItem(name: 'Test Item', quantity: 2, price: 20.0)]);
  });

  test('initial state should be OrderInitial', () => expect(orderBloc.state, equals(OrderInitial())));

  blocTest<OrderBloc, OrderState>(
    'loads combined orders via use cases',
    build: () {
      when(mockGetActiveOrders(const NoParams())).thenAnswer((_) async => Right(tActiveOrders));
      when(mockGetPastOrders(const NoParams())).thenAnswer((_) async => Right(tPastOrders));
      return orderBloc;
    },
    act: (bloc) => bloc.add(LoadOrdersEvent()),
    expect: () => [OrderLoading(), OrderLoaded(activeOrders: tActiveOrders, pastOrders: tPastOrders)],
  );

  blocTest<OrderBloc, OrderState>(
    'loads active orders via use case',
    build: () {
      when(mockGetActiveOrders(const NoParams())).thenAnswer((_) async => Right(tActiveOrders));
      return orderBloc;
    },
    act: (bloc) => bloc.add(LoadActiveOrdersEvent()),
    expect: () => [OrderLoading(), OrderLoaded(activeOrders: tActiveOrders, pastOrders: const [])],
  );

  blocTest<OrderBloc, OrderState>(
    'loads past orders via use case',
    build: () {
      when(mockGetPastOrders(const NoParams())).thenAnswer((_) async => Right(tPastOrders));
      return orderBloc;
    },
    act: (bloc) => bloc.add(LoadPastOrdersEvent()),
    expect: () => [OrderLoading(), OrderLoaded(activeOrders: const [], pastOrders: tPastOrders)],
  );

  blocTest<OrderBloc, OrderState>(
    'refreshes orders without loading state',
    build: () {
      when(mockGetActiveOrders(const NoParams())).thenAnswer((_) async => Right(tActiveOrders));
      when(mockGetPastOrders(const NoParams())).thenAnswer((_) async => Right(tPastOrders));
      return orderBloc;
    },
    act: (bloc) => bloc.add(RefreshOrdersEvent()),
    expect: () => [OrderLoaded(activeOrders: tActiveOrders, pastOrders: tPastOrders)],
  );

  blocTest<OrderBloc, OrderState>(
    'creates order through use case',
    build: () {
      when(mockCreateOrder(any)).thenAnswer((_) async => Right(tNewOrder));
      return orderBloc;
    },
    act: (bloc) => bloc.add(CreateOrderEvent(cartItems: tCartItems, deliveryAddress: '789 Elm St', paymentMethod: PaymentMethod.cashOnDelivery, subtotal: 40.0, deliveryFee: 5.0, notes: 'Test notes')),
    expect: () => [OrderCreating(), OrderCreateSuccess(tNewOrder)],
  );

  blocTest<OrderBloc, OrderState>(
    'emits create error on failure',
    build: () {
      when(mockCreateOrder(any)).thenAnswer((_) async => const Left(ServerFailure('Failed to create order')));
      return orderBloc;
    },
    act: (bloc) => bloc.add(CreateOrderEvent(cartItems: tCartItems, deliveryAddress: '789 Elm St', paymentMethod: PaymentMethod.cashOnDelivery, subtotal: 40.0, deliveryFee: 5.0)),
    expect: () => [OrderCreating(), const OrderCreateError('Failed to create order')],
  );
}
