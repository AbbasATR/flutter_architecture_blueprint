import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/l10n/app_localizations.dart';
import 'package:flutter_architecture_blueprint/shared/responsive/ui_scale.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/localization/locale_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock classes for testing
class MockThemeModeCubit extends MockCubit<ThemeMode>
    implements ThemeModeCubit {}

class MockLocaleCubit extends MockCubit<Locale> implements LocaleCubit {}

/// Extension to help pump widgets with BLoC providers in tests
extension PumpApp on WidgetTester {
  /// Pumps a widget wrapped in MaterialApp with localization and UIScaleScope support
  /// Optionally provide BLoC providers
  Future<void> pumpApp(Widget widget, {List<BlocProvider>? providers}) async {
    // Create default mock providers for commonly used cubits
    final mockThemeModeCubit = MockThemeModeCubit();
    final mockLocaleCubit = MockLocaleCubit();

    // Set up default states
    when(() => mockThemeModeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockLocaleCubit.state).thenReturn(const Locale('en'));

    // Create default providers list with essential providers
    final List<BlocProvider> defaultProviders = [
      BlocProvider<ThemeModeCubit>.value(value: mockThemeModeCubit),
      BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
    ];

    // Combine default providers with any additional providers
    final List<BlocProvider> allProviders = [
      ...defaultProviders,
      ...(providers ?? []),
    ];

    await pumpWidget(
      MultiBlocProvider(
        providers: allProviders,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
          builder: (context, child) {
            if (child == null) {
              return const SizedBox.shrink();
            }

            // Wrap with UIScaleScope to provide responsive utilities
            return UIScaleScope.wrap(context, child);
          },
        ),
      ),
    );

    // Ensure async localization and inherited widgets settle before assertions.
    await pumpAndSettle();
  }
}
