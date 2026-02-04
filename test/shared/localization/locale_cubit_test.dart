import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/shared/localization/locale_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late LocaleCubit localeCubit;
  late MockLocaleRepository mockRepository;

  setUp(() {
    mockRepository = MockLocaleRepository();
  });

  tearDown(() {
    localeCubit.close();
  });

  group('constructor and _loadLocale', () {
    test('initial state should be English when autoLoad is false', () {
      localeCubit = LocaleCubit(mockRepository, autoLoad: false);
      expect(localeCubit.state, equals(const Locale('en')));
      verifyNever(mockRepository.getLocale());
    });

    blocTest<LocaleCubit, Locale>(
      'should emit loaded locale when repository returns Arabic',
      build: () {
        when(
          mockRepository.getLocale(),
        ).thenAnswer((_) async => const Right(Locale('ar')));
        return LocaleCubit(mockRepository);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [const Locale('ar')],
      verify: (_) {
        verify(mockRepository.getLocale()).called(1);
      },
    );

    blocTest<LocaleCubit, Locale>(
      'should keep English when repository returns failure',
      build: () {
        when(
          mockRepository.getLocale(),
        ).thenAnswer((_) async => const Left(CacheFailure('No cached locale')));
        return LocaleCubit(mockRepository);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [],
      verify: (_) {
        verify(mockRepository.getLocale()).called(1);
      },
    );
  });

  group('setLocale', () {
    setUp(() {
      localeCubit = LocaleCubit(mockRepository, autoLoad: false);
    });

    blocTest<LocaleCubit, Locale>(
      'should save and emit Arabic locale',
      build: () => localeCubit,
      setUp: () {
        when(
          mockRepository.saveLocale(const Locale('ar')),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.setLocale(const Locale('ar')),
      expect: () => [const Locale('ar')],
      verify: (_) {
        verify(mockRepository.saveLocale(const Locale('ar'))).called(1);
      },
    );

    blocTest<LocaleCubit, Locale>(
      'should not emit when save fails',
      build: () => localeCubit,
      setUp: () {
        when(
          mockRepository.saveLocale(const Locale('ar')),
        ).thenAnswer((_) async => const Left(CacheFailure('Failed to save')));
      },
      act: (cubit) => cubit.setLocale(const Locale('ar')),
      expect: () => [],
      verify: (_) {
        verify(mockRepository.saveLocale(const Locale('ar'))).called(1);
      },
    );

    blocTest<LocaleCubit, Locale>(
      'should not call repository when setting same locale',
      build: () => localeCubit,
      act: (cubit) => cubit.setLocale(const Locale('en')),
      expect: () => [],
      verify: (_) {
        verifyNever(mockRepository.saveLocale(any));
      },
    );
  });

  group('toggleLocale', () {
    setUp(() {
      localeCubit = LocaleCubit(mockRepository, autoLoad: false);
    });

    blocTest<LocaleCubit, Locale>(
      'should toggle from English to Arabic',
      build: () => localeCubit,
      setUp: () {
        when(
          mockRepository.saveLocale(const Locale('ar')),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.toggleLocale(),
      expect: () => [const Locale('ar')],
    );

    blocTest<LocaleCubit, Locale>(
      'should toggle from Arabic to English',
      build: () => localeCubit,
      seed: () => const Locale('ar'),
      setUp: () {
        when(
          mockRepository.saveLocale(const Locale('en')),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.toggleLocale(),
      expect: () => [const Locale('en')],
    );
  });

  group('helper getters', () {
    setUp(() {
      localeCubit = LocaleCubit(mockRepository, autoLoad: false);
    });

    test('isArabic should return false when English', () {
      expect(localeCubit.isArabic, isFalse);
    });

    test('isEnglish should return true when English', () {
      expect(localeCubit.isEnglish, isTrue);
    });

    test('isArabic should return true when Arabic', () async {
      when(
        mockRepository.saveLocale(const Locale('ar')),
      ).thenAnswer((_) async => const Right(unit));

      await localeCubit.setLocale(const Locale('ar'));

      expect(localeCubit.isArabic, isTrue);
      expect(localeCubit.isEnglish, isFalse);
    });
  });
}
