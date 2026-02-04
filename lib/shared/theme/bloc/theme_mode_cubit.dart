import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/theme/domain/repositories/theme_mode_repository.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  final ThemeModeRepository _repository;
  final bool autoLoad;
  bool _isLoading = false;

  ThemeModeCubit(
    this._repository, {
    this.autoLoad = true,
    ThemeMode initialMode = ThemeMode.system,
  }) : super(initialMode) {
    if (autoLoad) {
      _loadTheme();
    }
  }

  bool get isLoading => _isLoading;

  /// Loads the saved theme mode from storage
  Future<void> _loadTheme() async {
    _isLoading = true;

    final themeResult = await _repository.getThemeMode();
    themeResult.fold(
      (failure) {
        debugPrint(
          '⚠️ ThemeModeCubit: Failed to load theme - ${failure.message}',
        );
        // Keep current state (system default)
      },
      (theme) {
        emit(theme);
      },
    );

    _isLoading = false;
  }

  /// Updates the theme mode and persists it to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return; // Already in this mode
    }

    final result = await _repository.saveThemeMode(mode);
    result.fold(
      (failure) {
        debugPrint(
          '⚠️ ThemeModeCubit: Failed to save theme - ${failure.message}',
        );
        // Don't change state if save failed
        // TODO: Consider emitting an error event or showing user feedback
      },
      (_) {
        emit(mode);
      },
    );
  }

  /// Returns true if the effective theme is dark
  /// Properly handles ThemeMode.system by checking device brightness
  bool get isDark {
    switch (state) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        final brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  /// Returns true if the effective theme is light
  bool get isLight => !isDark;

  /// Returns true if using system theme mode
  bool get isSystemMode => state == ThemeMode.system;

  /// Returns the effective theme mode, resolving system mode to light/dark
  ThemeMode get effectiveThemeMode {
    if (state == ThemeMode.system) {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
    return state;
  }

  /// Cycles through theme modes: system → light → dark → system
  Future<void> toggleThemeMode() async {
    final ThemeMode nextMode;
    switch (state) {
      case ThemeMode.system:
        nextMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        nextMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        nextMode = ThemeMode.system;
        break;
    }
    await setThemeMode(nextMode);
  }
}
