import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_state.dart'
    as supplier_state;
import 'package:flutter_architecture_blueprint/features/supplier/domain/usecases/get_suppliers_by_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_event.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_state.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SupplierBloc supplierBloc;
  late MockGetSuppliersByBusinessType mockGetSuppliersByBusinessType;

  setUp(() {
    mockGetSuppliersByBusinessType = MockGetSuppliersByBusinessType();
    supplierBloc = SupplierBloc(
      getSuppliersByBusinessType: mockGetSuppliersByBusinessType,
    );
  });

  tearDown(() {
    supplierBloc.close();
  });

  final tSuppliers = [
    const Supplier(
      id: 1,
      name: 'Pizza Palace',
      slogan: 'Best pizza in town',
      state: supplier_state.SupplierState.active,
      latLong: '40.7128,-74.0060',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'logo1.jpg',
      bannerURL: 'banner1.jpg',
      addressDescription: '123 Main St',
      minOrderAmount: 10.0,
      deliveryFeeBase: 5.0,
      operatingInfo: {},
      isClosed: false,
      rating: 4.5,
      reviewCount: 100,
      deliveryTimeMin: 30,
    ),
    const Supplier(
      id: 2,
      name: 'Burger House',
      slogan: 'Delicious burgers',
      state: supplier_state.SupplierState.active,
      latLong: '40.7589,-73.9851',
      businessType: SupplierBusinessType.restaurant,
      logoURL: 'logo2.jpg',
      bannerURL: 'banner2.jpg',
      addressDescription: '456 Oak Ave',
      minOrderAmount: 15.0,
      deliveryFeeBase: 3.0,
      operatingInfo: {},
      isClosed: false,
      rating: 4.2,
      reviewCount: 75,
      deliveryTimeMin: 25,
    ),
  ];

  const tBusinessType = SupplierBusinessType.restaurant;

  test('initial state should be SupplierInitial', () {
    expect(supplierBloc.state, equals(const SupplierInitial()));
  });

  group('LoadSuppliers', () {
    blocTest<SupplierBloc, SupplierState>(
      'should emit [Loading, Loaded] when loading suppliers succeeds',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => Right(tSuppliers));
        return supplierBloc;
      },
      act: (bloc) => bloc.add(const LoadSuppliers(tBusinessType)),
      expect: () => [const SupplierLoading(), SupplierLoaded(tSuppliers)],
      verify: (_) {
        verify(
          mockGetSuppliersByBusinessType(
            const GetSuppliersByBusinessTypeParams(businessType: tBusinessType),
          ),
        ).called(1);
      },
    );

    blocTest<SupplierBloc, SupplierState>(
      'should emit [Loading, Error] when loading suppliers fails',
      build: () {
        when(mockGetSuppliersByBusinessType(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to load suppliers')),
        );
        return supplierBloc;
      },
      act: (bloc) => bloc.add(const LoadSuppliers(tBusinessType)),
      expect: () => [
        const SupplierLoading(),
        const SupplierError('Failed to load suppliers'),
      ],
    );

    blocTest<SupplierBloc, SupplierState>(
      'should emit [Loading, Loaded] with empty list when no suppliers found',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => const Right([]));
        return supplierBloc;
      },
      act: (bloc) => bloc.add(const LoadSuppliers(tBusinessType)),
      expect: () => [const SupplierLoading(), const SupplierLoaded([])],
    );

    blocTest<SupplierBloc, SupplierState>(
      'should load suppliers for different business types',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => Right(tSuppliers));
        return supplierBloc;
      },
      act: (bloc) {
        bloc.add(const LoadSuppliers(SupplierBusinessType.grocery));
      },
      expect: () => [const SupplierLoading(), SupplierLoaded(tSuppliers)],
      verify: (_) {
        verify(
          mockGetSuppliersByBusinessType(
            const GetSuppliersByBusinessTypeParams(
              businessType: SupplierBusinessType.grocery,
            ),
          ),
        ).called(1);
      },
    );
  });

  group('RefreshSuppliers', () {
    blocTest<SupplierBloc, SupplierState>(
      'should emit [Loaded] when refreshing suppliers succeeds',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => Right(tSuppliers));
        return supplierBloc;
      },
      act: (bloc) => bloc.add(const RefreshSuppliers(tBusinessType)),
      expect: () => [SupplierLoaded(tSuppliers)],
      verify: (_) {
        verify(
          mockGetSuppliersByBusinessType(
            const GetSuppliersByBusinessTypeParams(businessType: tBusinessType),
          ),
        ).called(1);
      },
    );

    blocTest<SupplierBloc, SupplierState>(
      'should emit [Error] when refreshing suppliers fails',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
        return supplierBloc;
      },
      act: (bloc) => bloc.add(const RefreshSuppliers(tBusinessType)),
      expect: () => [const SupplierError('Network error')],
    );

    blocTest<SupplierBloc, SupplierState>(
      'should not emit Loading state when refreshing',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => Right(tSuppliers));
        return supplierBloc;
      },
      seed: () => const SupplierLoaded([]),
      act: (bloc) => bloc.add(const RefreshSuppliers(tBusinessType)),
      expect: () => [SupplierLoaded(tSuppliers)],
    );

    blocTest<SupplierBloc, SupplierState>(
      'should handle refresh with empty results',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => const Right([]));
        return supplierBloc;
      },
      seed: () => SupplierLoaded(tSuppliers),
      act: (bloc) => bloc.add(const RefreshSuppliers(tBusinessType)),
      expect: () => [const SupplierLoaded([])],
    );

    blocTest<SupplierBloc, SupplierState>(
      'should refresh suppliers for different business types',
      build: () {
        when(
          mockGetSuppliersByBusinessType(any),
        ).thenAnswer((_) async => Right(tSuppliers));
        return supplierBloc;
      },
      seed: () => const SupplierLoaded([]),
      act: (bloc) {
        bloc.add(const RefreshSuppliers(SupplierBusinessType.pharmacy));
      },
      expect: () => [SupplierLoaded(tSuppliers)],
      verify: (_) {
        verify(
          mockGetSuppliersByBusinessType(
            const GetSuppliersByBusinessTypeParams(
              businessType: SupplierBusinessType.pharmacy,
            ),
          ),
        ).called(1);
      },
    );
  });
}
