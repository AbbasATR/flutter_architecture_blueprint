import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AddressCubit addressCubit;
  late MockGetAddresses mockGetAddresses;
  late MockGetSelectedAddress mockGetSelectedAddress;
  late MockSelectAddress mockSelectAddress;

  setUp(() {
    mockGetAddresses = MockGetAddresses();
    mockGetSelectedAddress = MockGetSelectedAddress();
    mockSelectAddress = MockSelectAddress();
    addressCubit = AddressCubit(
      getAddresses: mockGetAddresses,
      getSelectedAddress: mockGetSelectedAddress,
      selectAddress: mockSelectAddress,
    );
  });

  tearDown(() {
    addressCubit.close();
  });

  final tAddresses = [
    const Address(id: '1', name: 'Home', details: '123 Main St', icon: 'home'),
    const Address(
      id: '2',
      name: 'Work',
      details: '456 Office Blvd',
      icon: 'work',
    ),
    const Address(
      id: '3',
      name: 'Other',
      details: '789 Other Ave',
      icon: 'location',
    ),
  ];
  final tSelectedAddress = tAddresses[0];

  test('initial state should be AddressInitial', () {
    expect(addressCubit.state, equals(AddressInitial()));
  });

  group('loadAddresses', () {
    blocTest<AddressCubit, AddressState>(
      'should emit [Loading, Loaded] when loading addresses with selected address succeeds',
      build: () {
        when(mockGetAddresses()).thenAnswer((_) async => tAddresses);
        when(
          mockGetSelectedAddress(),
        ).thenAnswer((_) async => tSelectedAddress);
        return addressCubit;
      },
      act: (cubit) => cubit.loadAddresses(),
      expect: () => [
        AddressLoading(),
        AddressLoaded(addresses: tAddresses, selectedAddress: tSelectedAddress),
      ],
      verify: (_) {
        verify(mockGetAddresses()).called(1);
        verify(mockGetSelectedAddress()).called(1);
      },
    );

    blocTest<AddressCubit, AddressState>(
      'should emit [Loading, Loaded] when loading addresses without selected address',
      build: () {
        when(mockGetAddresses()).thenAnswer((_) async => tAddresses);
        when(mockGetSelectedAddress()).thenAnswer((_) async => null);
        return addressCubit;
      },
      act: (cubit) => cubit.loadAddresses(),
      expect: () => [
        AddressLoading(),
        AddressLoaded(addresses: tAddresses, selectedAddress: null),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'should emit [Loading, Error] when loading addresses fails',
      build: () {
        when(
          mockGetAddresses(),
        ).thenThrow(Exception('Failed to load addresses'));
        return addressCubit;
      },
      act: (cubit) => cubit.loadAddresses(),
      expect: () => [
        AddressLoading(),
        isA<AddressError>().having(
          (e) => e.message,
          'message',
          contains('Failed to load addresses'),
        ),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'should emit [Loading, Error] when getting selected address fails',
      build: () {
        when(mockGetAddresses()).thenAnswer((_) async => tAddresses);
        when(
          mockGetSelectedAddress(),
        ).thenThrow(Exception('Failed to get selected'));
        return addressCubit;
      },
      act: (cubit) => cubit.loadAddresses(),
      expect: () => [
        AddressLoading(),
        isA<AddressError>().having(
          (e) => e.message,
          'message',
          contains('Failed to get selected'),
        ),
      ],
    );
  });

  group('selectAddressById', () {
    blocTest<AddressCubit, AddressState>(
      'should update selected address when selection succeeds',
      build: () {
        when(mockSelectAddress(any)).thenAnswer((_) async => Future.value());
        return addressCubit;
      },
      seed: () =>
          AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[0]),
      act: (cubit) => cubit.selectAddressById('2'),
      expect: () => [
        AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[1]),
      ],
      verify: (_) {
        verify(mockSelectAddress('2')).called(1);
      },
    );

    blocTest<AddressCubit, AddressState>(
      'should emit Error when selection fails',
      build: () {
        when(mockSelectAddress(any)).thenThrow(Exception('Selection failed'));
        return addressCubit;
      },
      seed: () =>
          AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[0]),
      act: (cubit) => cubit.selectAddressById('2'),
      expect: () => [
        isA<AddressError>().having(
          (e) => e.message,
          'message',
          contains('Selection failed'),
        ),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'should not emit when state is not AddressLoaded',
      build: () => addressCubit,
      seed: () => AddressInitial(),
      act: (cubit) => cubit.selectAddressById('2'),
      expect: () => [],
      verify: (_) {
        verifyNever(mockSelectAddress(any));
      },
    );

    blocTest<AddressCubit, AddressState>(
      'should keep addresses list unchanged when selecting',
      build: () {
        when(mockSelectAddress(any)).thenAnswer((_) async => Future.value());
        return addressCubit;
      },
      seed: () =>
          AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[0]),
      act: (cubit) => cubit.selectAddressById('3'),
      expect: () => [
        isA<AddressLoaded>()
            .having(
              (state) => state.addresses,
              'addresses unchanged',
              tAddresses,
            )
            .having(
              (state) => state.selectedAddress,
              'selected address updated',
              tAddresses[2],
            ),
      ],
    );
  });

  group('loadSelectedAddress', () {
    blocTest<AddressCubit, AddressState>(
      'should update selected address without changing addresses list',
      build: () {
        when(mockGetSelectedAddress()).thenAnswer((_) async => tAddresses[2]);
        return addressCubit;
      },
      seed: () =>
          AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[0]),
      act: (cubit) => cubit.loadSelectedAddress(),
      expect: () => [
        AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[2]),
      ],
      verify: (_) {
        verify(mockGetSelectedAddress()).called(1);
      },
    );

    blocTest<AddressCubit, AddressState>(
      'should emit Error when loading selected address fails',
      build: () {
        when(mockGetSelectedAddress()).thenThrow(Exception('Load failed'));
        return addressCubit;
      },
      seed: () =>
          AddressLoaded(addresses: tAddresses, selectedAddress: tAddresses[0]),
      act: (cubit) => cubit.loadSelectedAddress(),
      expect: () => [
        isA<AddressError>().having(
          (e) => e.message,
          'message',
          contains('Load failed'),
        ),
      ],
    );

    blocTest<AddressCubit, AddressState>(
      'should not emit when state is not AddressLoaded',
      build: () {
        when(mockGetSelectedAddress()).thenAnswer((_) async => tAddresses[1]);
        return addressCubit;
      },
      seed: () => AddressInitial(),
      act: (cubit) => cubit.loadSelectedAddress(),
      expect: () => [],
    );
  });
}
