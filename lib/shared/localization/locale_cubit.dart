import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/localization/domain/repositories/locale_repository.dart';

class LocaleCubit extends Cubit<Locale> {
  final LocaleRepository _repository;
  final bool autoLoad;
  bool _isLoading = false;

  LocaleCubit(
    this._repository, {
    this.autoLoad = true,
    Locale initialLocale = const Locale('en'),
  }) : super(initialLocale) {
    if (autoLoad) {
      _loadLocale();
    }
  }

  bool get isLoading => _isLoading;

  /// Loads the saved locale from storage
  Future<void> _loadLocale() async {
    _isLoading = true;

    final localeResult = await _repository.getLocale();
    localeResult.fold(
      (failure) {
        debugPrint(
          '⚠️ LocaleCubit: Failed to load locale - ${failure.message}',
        );
        // Keep current state (default locale)
      },
      (locale) {
        emit(locale);
      },
    );

    _isLoading = false;
  }

  /// Toggles between Arabic and English
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(newLocale);
  }

  /// Sets the locale and persists it to storage
  Future<void> setLocale(Locale locale) async {
    if (state.languageCode == locale.languageCode) {
      return; // Already in this locale
    }

    final result = await _repository.saveLocale(locale);
    result.fold(
      (failure) {
        debugPrint(
          '⚠️ LocaleCubit: Failed to save locale - ${failure.message}',
        );
        // Don't change state if save failed
      },
      (_) {
        emit(locale);
      },
    );
  }

  /// Returns true if current locale is Arabic
  bool get isArabic => state.languageCode == 'ar';

  /// Returns true if current locale is English
  bool get isEnglish => state.languageCode == 'en';
}
