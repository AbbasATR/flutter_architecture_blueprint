import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/screens/cart_screen.dart';
import 'package:flutter_architecture_blueprint/features/home/presentation/screens/home_tabs_screen.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/screens/orders_screen.dart';
import 'package:flutter_architecture_blueprint/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/shell_keys.dart';

/// Builds the navigation content for each tab
class ShellTabContent extends StatelessWidget {
  final BottomTab currentTab;

  const ShellTabContent({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentTab.index,
      children: BottomTab.values.map((tab) {
        return Offstage(
          offstage: currentTab != tab,
          child: Navigator(
            key: shellNavigatorKeys[tab],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => _getScreenForTab(tab),
                settings: settings,
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _getScreenForTab(BottomTab tab) {
    switch (tab) {
      case BottomTab.home:
        return const HomeTabsScreen();
      case BottomTab.cart:
        return const CartScreen();
      case BottomTab.orders:
        return const OrdersScreen();
      case BottomTab.profile:
        return const AccountSettingsScreen();
    }
  }
}
