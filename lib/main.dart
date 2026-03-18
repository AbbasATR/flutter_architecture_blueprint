import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/core/routers/app_router.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_architecture_blueprint/injection/injection_container.dart';
import 'package:flutter_architecture_blueprint/l10n/app_localizations.dart';
import 'package:flutter_architecture_blueprint/shared/localization/locale_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/responsive/ui_scale.dart';
import 'package:flutter_architecture_blueprint/shared/services/navigation_service.dart';
import 'package:flutter_architecture_blueprint/shared/theme/app_theme/app_theme.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navService = sl<NavigationService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested())),
        BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
        BlocProvider<LogoutBloc>(create: (_) => sl<LogoutBloc>()),
        BlocProvider<ThemeModeCubit>(create: (_) => sl<ThemeModeCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => sl<LocaleCubit>()),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'Flutter Architecture Blueprint',
                navigatorKey: navService.navigatorKey,
                onGenerateRoute: AppRouter.generateRoute,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                builder: (context, child) => UIScaleScope.wrap(context, child ?? const SizedBox.shrink()),
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading || state is AuthInitial) return const SplashScreen();
                    return LoginScreen();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
