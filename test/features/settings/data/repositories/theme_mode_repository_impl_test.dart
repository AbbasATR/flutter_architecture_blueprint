import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/shared/theme/data/repositories/theme_mode_repository_impl.dart';
import 'package:flutter_architecture_blueprint/shared/theme/theme_strings.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ThemeModeRepositoryImpl repository;
  late MockThemeModeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockThemeModeLocalDataSource();
    repository = ThemeModeRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('saveThemeMode', () {
    test('should return unit when theme mode is saved successfully', () async {
      // arrange
      const tThemeMode = ThemeMode.dark;
      when(
        mockLocalDataSource.saveThemeMode(any),
      ).thenAnswer((_) async => unit);

      // act
      final result = await repository.saveThemeMode(tThemeMode);

      // assert
      verify(mockLocalDataSource.saveThemeMode(tThemeMode));
      expect(result, const Right(unit));
    });

    test('should return UnknownFailure when save throws exception', () async {
      // arrange
      const tThemeMode = ThemeMode.light;
      when(
        mockLocalDataSource.saveThemeMode(any),
      ).thenThrow(Exception('Save failed'));

      // act
      final result = await repository.saveThemeMode(tThemeMode);

      // assert
      verify(mockLocalDataSource.saveThemeMode(tThemeMode));
      expect(result, Left(UnknownFailure()));
    });
  });

  group('getThemeMode', () {
    test('should return ThemeMode when theme mode exists in cache', () async {
      // arrange
      const tThemeMode = ThemeMode.dark;
      when(
        mockLocalDataSource.getThemeMode(),
      ).thenAnswer((_) async => tThemeMode);

      // act
      final result = await repository.getThemeMode();

      // assert
      verify(mockLocalDataSource.getThemeMode());
      expect(result, const Right(tThemeMode));
    });

    test(
      'should return CacheFailure when no cached theme mode found',
      () async {
        // arrange
        when(mockLocalDataSource.getThemeMode()).thenAnswer((_) async => null);

        // act
        final result = await repository.getThemeMode();

        // assert
        verify(mockLocalDataSource.getThemeMode());
        expect(result, Left(CacheFailure(ThemeStrings.noCachedThemeModeFound)));
      },
    );

    test('should return UnknownFailure when get throws exception', () async {
      // arrange
      when(
        mockLocalDataSource.getThemeMode(),
      ).thenThrow(Exception('Get failed'));

      // act
      final result = await repository.getThemeMode();

      // assert
      verify(mockLocalDataSource.getThemeMode());
      expect(result, Left(UnknownFailure()));
    });

    test('should handle ThemeMode.system correctly', () async {
      // arrange
      const tThemeMode = ThemeMode.system;
      when(
        mockLocalDataSource.getThemeMode(),
      ).thenAnswer((_) async => tThemeMode);

      // act
      final result = await repository.getThemeMode();

      // assert
      verify(mockLocalDataSource.getThemeMode());
      expect(result, const Right(tThemeMode));
    });
  });
}
