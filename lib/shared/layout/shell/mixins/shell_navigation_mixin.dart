import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/shell_keys.dart';

/// Mixin that provides navigation logic for the shell screen
mixin ShellNavigationMixin<T extends StatefulWidget> on State<T> {
  /// Handles system back button behavior
  Future<bool> handleSystemBack(BottomTab current) async {
    final nav = shellNavigatorKeys[current]!.currentState!;

    // If current tab navigator can pop, pop it
    if (nav.canPop()) {
      nav.pop();
      return false; // consumed
    }

    // If not on home tab, go to home tab
    if (current != BottomTab.home) {
      context.read<BottomNavCubit>().setTab(BottomTab.home);
      return false;
    }

    // Allow app to close
    return true;
  }

  /// Handles tab tap behavior
  void handleTabTap(int index, BottomTab current) {
    final tapped = BottomTab.values[index];

    if (tapped == current) {
      // Tapped current tab - pop to root or scroll to top
      _popToRootOrScrollToTop(current);
    } else {
      // Switch to tapped tab
      context.read<BottomNavCubit>().setTab(tapped);
    }
  }

  /// Pops to root of current tab or scrolls to top if already at root
  void _popToRootOrScrollToTop(BottomTab current) {
    final nav = shellNavigatorKeys[current]!.currentState!;
    var popped = false;

    // Pop all routes in current tab
    while (nav.canPop()) {
      popped = true;
      nav.pop();
    }

    // If didn't pop anything, scroll to top
    if (!popped) {
      _scrollToTop();
    }
  }

  /// Scrolls primary scrollable to top
  void _scrollToTop() {
    try {
      PrimaryScrollController.of(context).animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } catch (_) {
      // Ignore if no scroll controller available
    }
  }
}
