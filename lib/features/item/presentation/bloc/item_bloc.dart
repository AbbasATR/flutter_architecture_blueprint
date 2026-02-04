import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/usecases/get_items_by_supplier_id.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_event.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_state.dart';

/// BLoC for managing item state.
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetItemsBySupplierId getItemsBySupplierId;

  ItemBloc({required this.getItemsBySupplierId}) : super(const ItemInitial()) {
    on<LoadItems>(_onLoadItems);
    on<RefreshItems>(_onRefreshItems);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    emit(const ItemLoading());

    final result = await getItemsBySupplierId(
      GetItemsBySupplierIdParams(supplierId: event.supplierId),
    );

    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (items) => emit(ItemLoaded(items)),
    );
  }

  Future<void> _onRefreshItems(
    RefreshItems event,
    Emitter<ItemState> emit,
  ) async {
    // Keep current state while refreshing
    final result = await getItemsBySupplierId(
      GetItemsBySupplierIdParams(supplierId: event.supplierId),
    );

    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (items) => emit(ItemLoaded(items)),
    );
  }
}
