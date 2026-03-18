import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/core/usecases/usecase.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/entities/order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/create_order.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_active_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/domain/usecases/get_past_orders.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required this.getActiveOrders,
    required this.getPastOrders,
    required this.createOrder,
  }) : super(OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<LoadActiveOrdersEvent>(_onLoadActiveOrders);
    on<LoadPastOrdersEvent>(_onLoadPastOrders);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<CreateOrderEvent>(_onCreateOrder);
  }

  final GetActiveOrders getActiveOrders;
  final GetPastOrders getPastOrders;
  final CreateOrder createOrder;

  Future<void> _loadBothBuckets(Emitter<OrderState> emit) async {
    final activeResult = await getActiveOrders(NoParams());
    final pastResult = await getPastOrders(NoParams());

    if (activeResult.isLeft()) {
      emit(OrderError(activeResult.swap().getOrElse(() => throw StateError('No failure')).message));
      return;
    }
    if (pastResult.isLeft()) {
      emit(OrderError(pastResult.swap().getOrElse(() => throw StateError('No failure')).message));
      return;
    }

    emit(
      OrderLoaded(
        activeOrders: activeResult.getOrElse(() => const <Order>[]),
        pastOrders: pastResult.getOrElse(() => const <Order>[]),
      ),
    );
  }

  Future<void> _onLoadOrders(LoadOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    await _loadBothBuckets(emit);
  }

  Future<void> _onLoadActiveOrders(LoadActiveOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await getActiveOrders(NoParams());
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (activeOrders) => emit(OrderLoaded(activeOrders: activeOrders, pastOrders: state is OrderLoaded ? (state as OrderLoaded).pastOrders : const [])),
    );
  }

  Future<void> _onLoadPastOrders(LoadPastOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    final result = await getPastOrders(NoParams());
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (pastOrders) => emit(OrderLoaded(activeOrders: state is OrderLoaded ? (state as OrderLoaded).activeOrders : const [], pastOrders: pastOrders)),
    );
  }

  Future<void> _onRefreshOrders(RefreshOrdersEvent event, Emitter<OrderState> emit) async {
    await _loadBothBuckets(emit);
  }

  Future<void> _onCreateOrder(CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderCreating());
    final result = await createOrder(
      CreateOrderParams(
        cartItems: event.cartItems,
        deliveryAddress: event.deliveryAddress,
        paymentMethod: event.paymentMethod,
        subtotal: event.subtotal,
        deliveryFee: event.deliveryFee,
        notes: event.notes,
      ),
    );
    result.fold(
      (failure) => emit(OrderCreateError(failure.message)),
      (order) => emit(OrderCreateSuccess(order)),
    );
  }
}
