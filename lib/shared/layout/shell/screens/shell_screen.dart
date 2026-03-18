import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/injection/injection_container.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/mixins/shell_navigation_mixin.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/app_bar/shell_app_bar.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/shell_bottom_nav_bar.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/shell_tab_content.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> with ShellNavigationMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BottomNavCubit>()),
        BlocProvider(create: (_) => sl<AddressCubit>()..loadAddresses()),
        BlocProvider(create: (_) => sl<NotificationCubit>()..loadNotifications()),
        BlocProvider(create: (_) => sl<CartBloc>()..add(const LoadCartEvent())),
        BlocProvider(create: (_) => sl<OrderBloc>()..add(LoadOrdersEvent())),
      ],
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          final current = state.currentTab;
          final isVisible = state.isVisible;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (result, _) => handleSystemBack(current),
            child: Scaffold(
              appBar: current == BottomTab.home && isVisible ? const ShellAppBar() : null,
              body: ShellTabContent(currentTab: current),
              bottomNavigationBar: ShellBottomNavBar(
                currentTab: current,
                isVisible: isVisible,
                onTapTab: (index) => handleTabTap(index, current),
              ),
            ),
          );
        },
      ),
    );
  }
}
