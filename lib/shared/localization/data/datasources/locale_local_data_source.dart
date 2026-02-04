import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/core/error/exceptions.dart';
import 'package:flutter_architecture_blueprint/shared/localization/localization_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleLocalDataSource {
  /// Caches the locale locally.
  ///
  /// Takes a [Locale] object and stores it in local storage.
  Future<Unit> saveLocale(Locale locale);

  /// Retrieves the cached locale data.
  ///
  /// Returns a [Locale] object if found, otherwise returns null.
  Future<Locale?> getLocale();
}

const cachedLocale = LocalizationStrings.cacheLocale;

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  final SharedPreferences sharedPreferences;

  LocaleLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<Unit> saveLocale(Locale locale) {
    // Store language code in SharedPreferences
    final languageCode = locale.languageCode;
    sharedPreferences.setString(cachedLocale, languageCode);
    return Future.value(unit);
  }

  @override
  Future<Locale?> getLocale() {
    // Retrieve the cached locale from SharedPreferences
    final languageCode = sharedPreferences.getString(cachedLocale);
    if (languageCode != null) {
      return Future.value(Locale(languageCode));
    } else {
      // Return null if no cached locale found
      throw EmptyCacheException(LocalizationStrings.noCachedLocaleFound);
    }
  }
}
