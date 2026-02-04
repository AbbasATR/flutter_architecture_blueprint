import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_architecture_blueprint/features/home/domain/entities/home_bootstrap.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/cubit/home_bootstrap_cubit.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late HomeBootstrapCubit cubit;
  late MockGetHomeBootstrapUseCase mockGetHomeBootstrapUseCase;

  setUp(() {
    mockGetHomeBootstrapUseCase = MockGetHomeBootstrapUseCase();
    cubit = HomeBootstrapCubit(mockGetHomeBootstrapUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tHomeBootstrap = HomeBootstrap(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );

  test('initial state should be HomeBootstrapInitial', () {
    // assert
    expect(cubit.state, equals(HomeBootstrapInitial()));
  });

  group('loadHomeBootstrap', () {
    blocTest<HomeBootstrapCubit, HomeBootstrapState>(
      'should emit [Loading, Loaded] when data is fetched successfully',
      build: () {
        when(
          mockGetHomeBootstrapUseCase(),
        ).thenAnswer((_) async => tHomeBootstrap);
        return cubit;
      },
      act: (cubit) => cubit.loadHomeBootstrap(),
      expect: () => [
        HomeBootstrapLoading(),
        const HomeBootstrapLoaded(tHomeBootstrap),
      ],
      verify: (_) {
        verify(mockGetHomeBootstrapUseCase());
        verifyNoMoreInteractions(mockGetHomeBootstrapUseCase);
      },
    );

    blocTest<HomeBootstrapCubit, HomeBootstrapState>(
      'should emit [Loading, Error] when fetching data fails with exception',
      build: () {
        when(
          mockGetHomeBootstrapUseCase(),
        ).thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeBootstrap(),
      expect: () => [
        HomeBootstrapLoading(),
        isA<HomeBootstrapError>().having(
          (s) => s.message,
          'message',
          contains('Exception'),
        ),
      ],
    );

    blocTest<HomeBootstrapCubit, HomeBootstrapState>(
      'should emit [Loading, Error] when fetching data fails with server error',
      build: () {
        when(
          mockGetHomeBootstrapUseCase(),
        ).thenThrow(Exception('Server error occurred'));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeBootstrap(),
      expect: () => [
        HomeBootstrapLoading(),
        isA<HomeBootstrapError>().having(
          (s) => s.message,
          'message',
          contains('Server'),
        ),
      ],
    );

    blocTest<HomeBootstrapCubit, HomeBootstrapState>(
      'should emit [Loading, Error] when unexpected exception occurs',
      build: () {
        when(
          mockGetHomeBootstrapUseCase(),
        ).thenThrow(Exception('Unexpected error'));
        return cubit;
      },
      act: (cubit) => cubit.loadHomeBootstrap(),
      expect: () => [HomeBootstrapLoading(), isA<HomeBootstrapError>()],
    );
  });

  group('retry', () {
    blocTest<HomeBootstrapCubit, HomeBootstrapState>(
      'should retry loading and emit [Loading, Loaded] on success',
      build: () {
        when(
          mockGetHomeBootstrapUseCase(),
        ).thenAnswer((_) async => tHomeBootstrap);
        return cubit;
      },
      seed: () => const HomeBootstrapError('Previous error'),
      act: (cubit) => cubit.retry(),
      expect: () => [
        HomeBootstrapLoading(),
        const HomeBootstrapLoaded(tHomeBootstrap),
      ],
    );

    blocTest<HomeBootstrapCubit, HomeBootstrapState>(
      'should retry loading and emit [Loading, Error] on failure',
      build: () {
        when(
          mockGetHomeBootstrapUseCase(),
        ).thenThrow(Exception('Network error'));
        return cubit;
      },
      seed: () => const HomeBootstrapError('Previous error'),
      act: (cubit) => cubit.retry(),
      expect: () => [HomeBootstrapLoading(), isA<HomeBootstrapError>()],
    );
  });
}
