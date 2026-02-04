import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ThemeModeCubit themeModeCubit;
  late MockThemeModeRepository mockRepository;

  setUp(() {
    mockRepository = MockThemeModeRepository();
  });

  tearDown(() {
    themeModeCubit.close();
  });

  group('constructor and _loadTheme', () {
    test('initial state should be ThemeMode.system when autoLoad is false', () {
      // Act
      themeModeCubit = ThemeModeCubit(mockRepository, autoLoad: false);

      // Assert
      expect(themeModeCubit.state, equals(ThemeMode.system));
      verifyNever(mockRepository.getThemeMode());
    });

    test('initial state should be custom when initialMode is provided', () {
      // Act
      themeModeCubit = ThemeModeCubit(
        mockRepository,
        autoLoad: false,
        initialMode: ThemeMode.dark,
      );

      // Assert
      expect(themeModeCubit.state, equals(ThemeMode.dark));
    });

    blocTest<ThemeModeCubit, ThemeMode>(
      'should emit loaded theme when repository returns light mode',
      build: () {
        when(
          mockRepository.getThemeMode(),
        ).thenAnswer((_) async => const Right(ThemeMode.light));
        return ThemeModeCubit(mockRepository);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(mockRepository.getThemeMode()).called(1);
      },
    );

    blocTest<ThemeModeCubit, ThemeMode>(
      'should emit loaded theme when repository returns dark mode',
      build: () {
        when(
          mockRepository.getThemeMode(),
        ).thenAnswer((_) async => const Right(ThemeMode.dark));
        return ThemeModeCubit(mockRepository);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(mockRepository.getThemeMode()).called(1);
      },
    );

    blocTest<ThemeModeCubit, ThemeMode>(
      'should keep system mode when repository returns failure',
      build: () {
        when(mockRepository.getThemeMode()).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to load theme')),
        );
        return ThemeModeCubit(mockRepository);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [],
      verify: (_) {
        verify(mockRepository.getThemeMode()).called(1);
      },
    );

    blocTest<ThemeModeCubit, ThemeMode>(
      'should not emit when setThemeMode fails to save',
      build: () {
        return ThemeModeCubit(mockRepository, autoLoad: false);
      },
      setUp: () {
        when(
          mockRepository.saveThemeMode(ThemeMode.dark),
        ).thenAnswer((_) async => const Left(CacheFailure('Failed to save')));
      },
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      wait: const Duration(milliseconds: 100),
      expect: () => [],
      verify: (_) {
        verify(mockRepository.saveThemeMode(ThemeMode.dark)).called(1);
      },
    );

    blocTest<ThemeModeCubit, ThemeMode>(
      'should not call repository when setting same theme mode',
      build: () {
        return ThemeModeCubit(
          mockRepository,
          autoLoad: false,
          initialMode: ThemeMode.dark,
        );
      },
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      wait: const Duration(milliseconds: 100),
      expect: () => [],
      verify: (_) {
        verifyNever(mockRepository.saveThemeMode(any));
      },
    );
  });

  group('setThemeMode', () {
    setUp(() {
      when(
        mockRepository.getThemeMode(),
      ).thenAnswer((_) async => const Right(ThemeMode.system));
      themeModeCubit = ThemeModeCubit(mockRepository, autoLoad: false);
    });

    blocTest<ThemeModeCubit, ThemeMode>(
      'should save and emit light mode',
      build: () => themeModeCubit,
      setUp: () {
        when(
          mockRepository.saveThemeMode(ThemeMode.light),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.setThemeMode(ThemeMode.light),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(mockRepository.saveThemeMode(ThemeMode.light)).called(1);
      },
    );

    blocTest<ThemeModeCubit, ThemeMode>(
      'should save and emit dark mode',
      build: () => themeModeCubit,
      setUp: () {
        when(
          mockRepository.saveThemeMode(ThemeMode.dark),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(mockRepository.saveThemeMode(ThemeMode.dark)).called(1);
      },
    );

    blocTest<ThemeModeCubit, ThemeMode>(
      'should save and emit system mode',
      build: () => themeModeCubit,
      setUp: () {
        when(
          mockRepository.saveThemeMode(ThemeMode.system),
        ).thenAnswer((_) async => const Right(unit));
      },
      seed: () => ThemeMode.light,
      act: (cubit) => cubit.setThemeMode(ThemeMode.system),
      expect: () => [ThemeMode.system],
      verify: (_) {
        verify(mockRepository.saveThemeMode(ThemeMode.system)).called(1);
      },
    );
  });

  group('isDark getter', () {
    setUp(() {
      when(
        mockRepository.getThemeMode(),
      ).thenAnswer((_) async => const Right(ThemeMode.system));
      themeModeCubit = ThemeModeCubit(mockRepository, autoLoad: false);
    });

    test('should return true when theme is dark', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.dark),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.dark);

      // Assert
      expect(themeModeCubit.isDark, isTrue);
    });

    test('should return false when theme is light', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.light),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.light);

      // Assert
      expect(themeModeCubit.isDark, isFalse);
    });
  });

  group('isLight getter', () {
    setUp(() {
      themeModeCubit = ThemeModeCubit(mockRepository, autoLoad: false);
    });

    test('should return true when theme is light', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.light),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.light);

      // Assert
      expect(themeModeCubit.isLight, isTrue);
    });

    test('should return false when theme is dark', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.dark),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.dark);

      // Assert
      expect(themeModeCubit.isLight, isFalse);
    });
  });

  group('isSystemMode getter', () {
    setUp(() {
      themeModeCubit = ThemeModeCubit(mockRepository, autoLoad: false);
    });

    test('should return true when theme is system', () {
      expect(themeModeCubit.isSystemMode, isTrue);
    });

    test('should return false when theme is light', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.light),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.light);

      // Assert
      expect(themeModeCubit.isSystemMode, isFalse);
    });
  });

  group('toggleThemeMode', () {
    setUp(() {
      themeModeCubit = ThemeModeCubit(mockRepository, autoLoad: false);
    });

    test('should cycle from system to light', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.light),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.toggleThemeMode();

      // Assert
      expect(themeModeCubit.state, equals(ThemeMode.light));
    });

    test('should cycle from light to dark', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.light),
      ).thenAnswer((_) async => const Right(unit));
      when(
        mockRepository.saveThemeMode(ThemeMode.dark),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.light);
      await themeModeCubit.toggleThemeMode();

      // Assert
      expect(themeModeCubit.state, equals(ThemeMode.dark));
    });

    test('should cycle from dark to system', () async {
      // Arrange
      when(
        mockRepository.saveThemeMode(ThemeMode.dark),
      ).thenAnswer((_) async => const Right(unit));
      when(
        mockRepository.saveThemeMode(ThemeMode.system),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await themeModeCubit.setThemeMode(ThemeMode.dark);
      await themeModeCubit.toggleThemeMode();

      // Assert
      expect(themeModeCubit.state, equals(ThemeMode.system));
    });
  });
}
