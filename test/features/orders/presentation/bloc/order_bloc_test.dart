import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_type.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item_status.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late OrderBloc orderBloc;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    orderBloc = OrderBloc(repository: mockOrderRepository);
  });

  tearDown(() {
    orderBloc.close();
  });

  final tActiveOrders = [
    Order(
      id: 1,
      timestamp: DateTime(2024, 1, 1),
      orderedById: 1,
      status: OrderStatus.processing,
      cashPaid: 50.0,
      pointsPaid: 0,
      isSettled: false,
      identifier: 'ORD-001',
      paymentMethod: PaymentMethod.cashOnDelivery,
      subtotalAmount: 40.0,
      discountTotal: 0.0,
      deliveryFee: 10.0,
      prepMinutes: 30,
      dropoffAddress: '123 Main St',
      supplierName: 'Test Restaurant',
      items: const [OrderItem(name: 'Pizza', quantity: 2, price: 20.0)],
    ),
  ];

  final tPastOrders = [
    Order(
      id: 2,
      timestamp: DateTime(2023, 12, 1),
      orderedById: 1,
      status: OrderStatus.delivered,
      cashPaid: 30.0,
      pointsPaid: 0,
      isSettled: true,
      identifier: 'ORD-002',
      paymentMethod: PaymentMethod.card,
      subtotalAmount: 25.0,
      discountTotal: 0.0,
      deliveryFee: 5.0,
      prepMinutes: 20,
      dropoffAddress: '456 Oak Ave',
      supplierName: 'Burger Place',
      items: const [OrderItem(name: 'Burger', quantity: 1, price: 25.0)],
      deliveredAt: DateTime(2023, 12, 1, 14, 30),
    ),
  ];

  final tItem = Item(
    id: 1,
    name: 'Test Item',
    shortDescription: 'Short desc',
    description: 'Full description',
    imageURL: 'test.jpg',
    price: 20.0,
    categoryId: 1,
    supplierId: 1,
    isAvailable: true,
    rating: 4.5,
    reviewCount: 10,
    updatedAt: DateTime(2024, 1, 1),
    type: ItemType.food,
    metadata: {},
    prepTimeMinutes: 30,
    status: ItemStatus.available,
  );

  final tCartItems = [
    CartItem(
      id: '1',
      item: tItem,
      quantity: 2,
      sizePrice: 0.0,
      addedAt: DateTime(2024, 1, 1),
    ),
  ];

  final tNewOrder = Order(
    id: 3,
    timestamp: DateTime(2024, 1, 2),
    orderedById: 1,
    status: OrderStatus.ordered,
    cashPaid: 45.0,
    pointsPaid: 0,
    isSettled: false,
    identifier: 'ORD-003',
    paymentMethod: PaymentMethod.cashOnDelivery,
    subtotalAmount: 40.0,
    discountTotal: 0.0,
    deliveryFee: 5.0,
    prepMinutes: 25,
    dropoffAddress: '789 Elm St',
    supplierName: 'Pizza Place',
    items: const [OrderItem(name: 'Test Item', quantity: 2, price: 20.0)],
  );

  test('initial state should be OrderInitial', () {
    expect(orderBloc.state, equals(OrderInitial()));
  });

  group('LoadOrdersEvent', () {
    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Loaded] when loading all orders succeeds',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => Right(tActiveOrders));
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadOrdersEvent()),
      expect: () => [
        OrderLoading(),
        OrderLoaded(activeOrders: tActiveOrders, pastOrders: tPastOrders),
      ],
      verify: (_) {
        verify(mockOrderRepository.getActiveOrders()).called(1);
        verify(mockOrderRepository.getPastOrders()).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Error] when loading active orders fails',
      build: () {
        when(mockOrderRepository.getActiveOrders()).thenAnswer(
          (_) async =>
              const Left(ServerFailure('Failed to load active orders')),
        );
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadOrdersEvent()),
      expect: () => [
        OrderLoading(),
        const OrderError('Failed to load active orders'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Error] when loading past orders fails',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => Right(tActiveOrders));
        when(mockOrderRepository.getPastOrders()).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to load past orders')),
        );
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadOrdersEvent()),
      expect: () => [
        OrderLoading(),
        const OrderError('Failed to load past orders'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Loaded] with empty lists when no orders found',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => const Right([]));
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => const Right([]));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadOrdersEvent()),
      expect: () => [
        OrderLoading(),
        const OrderLoaded(activeOrders: [], pastOrders: []),
      ],
    );
  });

  group('LoadActiveOrdersEvent', () {
    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Loaded] when loading active orders succeeds',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => Right(tActiveOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadActiveOrdersEvent()),
      expect: () => [
        OrderLoading(),
        OrderLoaded(activeOrders: tActiveOrders, pastOrders: const []),
      ],
      verify: (_) {
        verify(mockOrderRepository.getActiveOrders()).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Error] when loading active orders fails',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadActiveOrdersEvent()),
      expect: () => [OrderLoading(), const OrderError('Network error')],
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Loaded] without maintaining past orders due to Loading state',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => Right(tActiveOrders));
        return orderBloc;
      },
      seed: () => OrderLoaded(activeOrders: const [], pastOrders: tPastOrders),
      act: (bloc) => bloc.add(LoadActiveOrdersEvent()),
      expect: () => [
        OrderLoading(),
        OrderLoaded(activeOrders: tActiveOrders, pastOrders: const []),
      ],
    );
  });

  group('LoadPastOrdersEvent', () {
    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Loaded] when loading past orders succeeds',
      build: () {
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadPastOrdersEvent()),
      expect: () => [
        OrderLoading(),
        OrderLoaded(activeOrders: const [], pastOrders: tPastOrders),
      ],
      verify: (_) {
        verify(mockOrderRepository.getPastOrders()).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Error] when loading past orders fails',
      build: () {
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return orderBloc;
      },
      act: (bloc) => bloc.add(LoadPastOrdersEvent()),
      expect: () => [OrderLoading(), const OrderError('Server error')],
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Loading, Loaded] without maintaining active orders due to Loading state',
      build: () {
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      seed: () =>
          OrderLoaded(activeOrders: tActiveOrders, pastOrders: const []),
      act: (bloc) => bloc.add(LoadPastOrdersEvent()),
      expect: () => [
        OrderLoading(),
        OrderLoaded(activeOrders: const [], pastOrders: tPastOrders),
      ],
    );
  });

  group('RefreshOrdersEvent', () {
    blocTest<OrderBloc, OrderState>(
      'should emit [Loaded] when refreshing orders succeeds',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => Right(tActiveOrders));
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(RefreshOrdersEvent()),
      expect: () => [
        OrderLoaded(activeOrders: tActiveOrders, pastOrders: tPastOrders),
      ],
      verify: (_) {
        verify(mockOrderRepository.getActiveOrders()).called(1);
        verify(mockOrderRepository.getPastOrders()).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Error] when refreshing orders fails',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => const Left(ServerFailure('Refresh failed')));
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      act: (bloc) => bloc.add(RefreshOrdersEvent()),
      expect: () => [const OrderError('Refresh failed')],
    );

    blocTest<OrderBloc, OrderState>(
      'should not emit Loading state when refreshing',
      build: () {
        when(
          mockOrderRepository.getActiveOrders(),
        ).thenAnswer((_) async => Right(tActiveOrders));
        when(
          mockOrderRepository.getPastOrders(),
        ).thenAnswer((_) async => Right(tPastOrders));
        return orderBloc;
      },
      seed: () => const OrderLoaded(activeOrders: [], pastOrders: []),
      act: (bloc) => bloc.add(RefreshOrdersEvent()),
      expect: () => [
        OrderLoaded(activeOrders: tActiveOrders, pastOrders: tPastOrders),
      ],
    );
  });

  group('CreateOrderEvent', () {
    blocTest<OrderBloc, OrderState>(
      'should emit [Creating, CreateSuccess] when creating order succeeds',
      build: () {
        when(
          mockOrderRepository.createOrder(
            cartItems: anyNamed('cartItems'),
            deliveryAddress: anyNamed('deliveryAddress'),
            paymentMethod: anyNamed('paymentMethod'),
            subtotal: anyNamed('subtotal'),
            deliveryFee: anyNamed('deliveryFee'),
            notes: anyNamed('notes'),
          ),
        ).thenAnswer((_) async => Right(tNewOrder));
        return orderBloc;
      },
      act: (bloc) => bloc.add(
        CreateOrderEvent(
          cartItems: tCartItems,
          deliveryAddress: '789 Elm St',
          paymentMethod: PaymentMethod.cashOnDelivery,
          subtotal: 40.0,
          deliveryFee: 5.0,
          notes: 'Test notes',
        ),
      ),
      expect: () => [OrderCreating(), OrderCreateSuccess(tNewOrder)],
      verify: (_) {
        verify(
          mockOrderRepository.createOrder(
            cartItems: tCartItems,
            deliveryAddress: '789 Elm St',
            paymentMethod: PaymentMethod.cashOnDelivery,
            subtotal: 40.0,
            deliveryFee: 5.0,
            notes: 'Test notes',
          ),
        ).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'should emit [Creating, CreateError] when creating order fails',
      build: () {
        when(
          mockOrderRepository.createOrder(
            cartItems: anyNamed('cartItems'),
            deliveryAddress: anyNamed('deliveryAddress'),
            paymentMethod: anyNamed('paymentMethod'),
            subtotal: anyNamed('subtotal'),
            deliveryFee: anyNamed('deliveryFee'),
            notes: anyNamed('notes'),
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to create order')),
        );
        return orderBloc;
      },
      act: (bloc) => bloc.add(
        CreateOrderEvent(
          cartItems: tCartItems,
          deliveryAddress: '789 Elm St',
          paymentMethod: PaymentMethod.cashOnDelivery,
          subtotal: 40.0,
          deliveryFee: 5.0,
        ),
      ),
      expect: () => [
        OrderCreating(),
        const OrderCreateError('Failed to create order'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'should handle order creation without notes',
      build: () {
        when(
          mockOrderRepository.createOrder(
            cartItems: anyNamed('cartItems'),
            deliveryAddress: anyNamed('deliveryAddress'),
            paymentMethod: anyNamed('paymentMethod'),
            subtotal: anyNamed('subtotal'),
            deliveryFee: anyNamed('deliveryFee'),
            notes: anyNamed('notes'),
          ),
        ).thenAnswer((_) async => Right(tNewOrder));
        return orderBloc;
      },
      act: (bloc) => bloc.add(
        CreateOrderEvent(
          cartItems: tCartItems,
          deliveryAddress: '789 Elm St',
          paymentMethod: PaymentMethod.card,
          subtotal: 40.0,
          deliveryFee: 5.0,
        ),
      ),
      expect: () => [OrderCreating(), OrderCreateSuccess(tNewOrder)],
    );
  });
}
