import 'package:flutter/material.dart';
import 'bottom_tab.dart';

/// Navigator keys for each bottom tab to maintain independent navigation stacks.
final Map<BottomTab, GlobalKey<NavigatorState>> shellNavigatorKeys = {
  for (final tab in BottomTab.values) tab: GlobalKey<NavigatorState>(),
};
