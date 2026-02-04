import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/usecases/get_suppliers_by_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_event.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_state.dart';

/// BLoC for managing supplier state.
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final GetSuppliersByBusinessType getSuppliersByBusinessType;

  SupplierBloc({required this.getSuppliersByBusinessType})
    : super(const SupplierInitial()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<RefreshSuppliers>(_onRefreshSuppliers);
  }

  Future<void> _onLoadSuppliers(
    LoadSuppliers event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierLoading());

    final result = await getSuppliersByBusinessType(
      GetSuppliersByBusinessTypeParams(businessType: event.businessType),
    );

    result.fold(
      (failure) => emit(SupplierError(failure.message)),
      (suppliers) => emit(SupplierLoaded(suppliers)),
    );
  }

  Future<void> _onRefreshSuppliers(
    RefreshSuppliers event,
    Emitter<SupplierState> emit,
  ) async {
    // Keep current state while refreshing
    final result = await getSuppliersByBusinessType(
      GetSuppliersByBusinessTypeParams(businessType: event.businessType),
    );

    result.fold(
      (failure) => emit(SupplierError(failure.message)),
      (suppliers) => emit(SupplierLoaded(suppliers)),
    );
  }
}
