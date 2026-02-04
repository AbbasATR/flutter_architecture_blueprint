import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_business_type.dart';
import 'package:flutter_architecture_blueprint/features/supplier/domain/entities/supplier_state.dart'
    as supplier_state;
import 'package:flutter_architecture_blueprint/features/supplier/domain/usecases/get_suppliers_by_business_type.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetSuppliersByBusinessType usecase;
  late MockSupplierRepository mockSupplierRepository;

  setUp(() {
    mockSupplierRepository = MockSupplierRepository();
    usecase = GetSuppliersByBusinessType(mockSupplierRepository);
  });

  const tBusinessType = SupplierBusinessType.restaurant;
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

  test('should return list of suppliers from repository', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => Right(tSuppliers));

    // act
    final result = await usecase(
      const GetSuppliersByBusinessTypeParams(businessType: tBusinessType),
    );

    // assert
    expect(result, Right(tSuppliers));
    verify(mockSupplierRepository.getSuppliersByBusinessType(tBusinessType));
    verifyNoMoreInteractions(mockSupplierRepository);
  });

  test('should return empty list when no suppliers found', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    final result = await usecase(
      const GetSuppliersByBusinessTypeParams(businessType: tBusinessType),
    );

    // assert
    expect(result, const Right<Failure, List<Supplier>>([]));
    verify(mockSupplierRepository.getSuppliersByBusinessType(tBusinessType));
  });

  test('should return ServerFailure when repository call fails', () async {
    // arrange
    const tFailure = ServerFailure('Failed to fetch suppliers');
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(
      const GetSuppliersByBusinessTypeParams(businessType: tBusinessType),
    );

    // assert
    expect(result, const Left(tFailure));
    verify(mockSupplierRepository.getSuppliersByBusinessType(tBusinessType));
  });

  test('should return CacheFailure when offline and no cache', () async {
    // arrange
    const tFailure = CacheFailure('No cached data available');
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase(
      const GetSuppliersByBusinessTypeParams(businessType: tBusinessType),
    );

    // assert
    expect(result, const Left(tFailure));
    verify(mockSupplierRepository.getSuppliersByBusinessType(tBusinessType));
  });

  test('should handle restaurant business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => Right(tSuppliers));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.restaurant,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.restaurant,
      ),
    );
  });

  test('should handle grocery business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.grocery,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.grocery,
      ),
    );
  });

  test('should handle pharmacy business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.pharmacy,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.pharmacy,
      ),
    );
  });

  test('should handle shopping business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.shopping,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.shopping,
      ),
    );
  });

  test('should handle flowers business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.flowers,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.flowers,
      ),
    );
  });

  test('should handle electronics business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.electronics,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.electronics,
      ),
    );
  });

  test('should handle other business type', () async {
    // arrange
    when(
      mockSupplierRepository.getSuppliersByBusinessType(any),
    ).thenAnswer((_) async => const Right<Failure, List<Supplier>>([]));

    // act
    await usecase(
      const GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.other,
      ),
    );

    // assert
    verify(
      mockSupplierRepository.getSuppliersByBusinessType(
        SupplierBusinessType.other,
      ),
    );
  });

  group('GetSuppliersByBusinessTypeParams', () {
    test('should have correct props for equality', () {
      const params1 = GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.restaurant,
      );
      const params2 = GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.restaurant,
      );
      const params3 = GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.grocery,
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('should return correct props list', () {
      const params = GetSuppliersByBusinessTypeParams(
        businessType: SupplierBusinessType.restaurant,
      );
      expect(params.props, [SupplierBusinessType.restaurant]);
    });
  });
}
