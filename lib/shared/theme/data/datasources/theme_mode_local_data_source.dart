import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/shared/theme/theme_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeModeLocalDataSource {
  /// Caches the theme mode locally.
  ///
  /// Takes a [ThemeMode] object and stores it in local storage.
  Future<Unit> saveThemeMode(ThemeMode mode);

  /// Retrieves the cached template data.
  ///
  /// Returns a [ThemeMode] object if found, otherwise returns null.
  Future<ThemeMode?> getThemeMode();
}

const cashedThemeMode = ThemeStrings.cacheThemeMode;

class ThemeModeLocalDataSourceImpl implements ThemeModeLocalDataSource {
  final SharedPreferences sharedPreferences;
  ThemeModeLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<Unit> saveThemeMode(ThemeMode mode) {
    // Convert ThemeMode to String and store it in SharedPreferences
    final modeString = mode.toString();
    sharedPreferences.setString(cashedThemeMode, modeString);
    return Future.value(unit);
  }

  @override
  Future<ThemeMode?> getThemeMode() {
    // Retrieve the cached theme mode from SharedPreferences
    final modeString = sharedPreferences.getString(cashedThemeMode);
    if (modeString != null) {
      // Convert String back to ThemeMode
      return Future.value(
        ThemeMode.values.firstWhere(
          (e) => e.toString() == modeString,
          orElse: () => ThemeMode.system,
        ),
      );
    } else {
      // Return null if no cached theme mode found
      throw EmptyCacheException(ThemeStrings.noCachedThemeModeFound);
    }
  }
}
