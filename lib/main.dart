import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/item/presentation/bloc/item_bloc.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_architecture_blueprint/features/supplier/presentation/bloc/supplier_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/responsive/ui_scale.dart';
import 'package:flutter_architecture_blueprint/shared/theme/app_theme/app_theme.dart';
import 'package:flutter_architecture_blueprint/core/routers/app_router.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_architecture_blueprint/shared/theme/bloc/theme_mode_cubit.dart';
import 'package:flutter_architecture_blueprint/injection/injection_container.dart';
import 'package:flutter_architecture_blueprint/l10n/app_localizations.dart';
import 'package:flutter_architecture_blueprint/shared/localization/locale_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  await sl.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navService = sl<NavigationService>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
        BlocProvider<LogoutBloc>(create: (_) => sl<LogoutBloc>()),
        BlocProvider<ThemeModeCubit>(create: (_) => sl<ThemeModeCubit>()),
        BlocProvider<LocaleCubit>(create: (_) => sl<LocaleCubit>()),
        BlocProvider<BottomNavCubit>(create: (_) => sl<BottomNavCubit>()),
        BlocProvider<AddressCubit>(
          create: (_) => sl<AddressCubit>()..loadAddresses(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => sl<NotificationCubit>()..loadNotifications(),
        ),
        BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
        BlocProvider<SupplierBloc>(create: (_) => sl<SupplierBloc>()),
        BlocProvider<ItemBloc>(create: (_) => sl<ItemBloc>()),
        BlocProvider<CartBloc>(
          create: (_) => sl<CartBloc>()..add(const LoadCartEvent()),
        ),
        BlocProvider<OrderBloc>(
          create: (_) => sl<OrderBloc>()..add(LoadOrdersEvent()),
        ),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            bloc: sl<LocaleCubit>(),
            builder: (context, locale) {
              return MaterialApp(
                title: 'Flutter Architecture Blueprint',
                navigatorKey: _navService.navigatorKey,
                onGenerateRoute: AppRouter.generateRoute,
                locale: locale, // Use locale directly
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                builder: (context, child) {
                  final safeChild = child ?? const SizedBox.shrink();
                  return UIScaleScope.wrap(context, safeChild);
                },
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading || state is AuthInitial) {
                      return const SplashScreen();
                    } else {
                      return LoginScreen();
                    }
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
