import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/repositories/order_repository.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<LoadActiveOrdersEvent>(_onLoadActiveOrders);
    on<LoadPastOrdersEvent>(_onLoadPastOrders);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final activeResult = await repository.getActiveOrders();
    final pastResult = await repository.getPastOrders();

    List<Order> activeOrders = [];
    List<Order> pastOrders = [];

    activeResult.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => activeOrders = orders,
    );

    pastResult.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => pastOrders = orders,
    );

    if (state is! OrderError) {
      emit(OrderLoaded(activeOrders: activeOrders, pastOrders: pastOrders));
    }
  }

  Future<void> _onLoadActiveOrders(
    LoadActiveOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await repository.getActiveOrders();

    result.fold((failure) => emit(OrderError(failure.message)), (activeOrders) {
      if (state is OrderLoaded) {
        emit(
          OrderLoaded(
            activeOrders: activeOrders,
            pastOrders: (state as OrderLoaded).pastOrders,
          ),
        );
      } else {
        emit(OrderLoaded(activeOrders: activeOrders, pastOrders: const []));
      }
    });
  }

  Future<void> _onLoadPastOrders(
    LoadPastOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    final result = await repository.getPastOrders();

    result.fold((failure) => emit(OrderError(failure.message)), (pastOrders) {
      if (state is OrderLoaded) {
        emit(
          OrderLoaded(
            activeOrders: (state as OrderLoaded).activeOrders,
            pastOrders: pastOrders,
          ),
        );
      } else {
        emit(OrderLoaded(activeOrders: const [], pastOrders: pastOrders));
      }
    });
  }

  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    final activeResult = await repository.getActiveOrders();
    final pastResult = await repository.getPastOrders();

    List<Order> activeOrders = [];
    List<Order> pastOrders = [];

    activeResult.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => activeOrders = orders,
    );

    pastResult.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => pastOrders = orders,
    );

    if (state is! OrderError) {
      emit(OrderLoaded(activeOrders: activeOrders, pastOrders: pastOrders));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderCreating());

    final result = await repository.createOrder(
      cartItems: event.cartItems,
      deliveryAddress: event.deliveryAddress,
      paymentMethod: event.paymentMethod,
      subtotal: event.subtotal,
      deliveryFee: event.deliveryFee,
      notes: event.notes,
    );

    result.fold(
      (failure) => emit(OrderCreateError(failure.message)),
      (order) => emit(OrderCreateSuccess(order)),
    );
  }
}
