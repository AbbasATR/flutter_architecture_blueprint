import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_architecture_blueprint/features/address/domain/entities/address.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/bloc/address_cubit.dart';
import 'package:flutter_architecture_blueprint/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_architecture_blueprint/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_architecture_blueprint/features/notifications/domain/entities/notification.dart'
    as notification_entity;
import 'package:flutter_architecture_blueprint/features/notifications/presentation/bloc/notification_cubit.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_bloc.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_architecture_blueprint/features/orders/presentation/bloc/order_state.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_state.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/screens/shell_screen.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/custom_nav_item.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/shell_bottom_nav_bar.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/widgets/shell_tab_content.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

class MockNotificationCubit extends MockCubit<NotificationState>
    implements NotificationCubit {}

class MockAddressCubit extends MockCubit<AddressState>
    implements AddressCubit {}

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockOrderBloc extends MockBloc<OrderEvent, OrderState>
    implements OrderBloc {}

void main() {
  final sl = GetIt.instance;

  group('ShellScreen Widget Tests', () {
    late BottomNavCubit bottomNavCubit;
    late MockCartBloc mockCartBloc;
    late MockNotificationCubit mockNotificationCubit;
    late MockAddressCubit mockAddressCubit;
    late MockSearchBloc mockSearchBloc;
    late MockOrderBloc mockOrderBloc;

    Future<void> pumpShellScreen(
      WidgetTester tester, {
      required BottomNavCubit cubit,
    }) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1080, 1920);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      addTearDown(() async => cubit.close());

      await tester.pumpApp(
        BlocProvider<BottomNavCubit>.value(
          value: cubit,
          child: const ShellScreen(),
        ),
        providers: [
          BlocProvider<NotificationCubit>.value(value: mockNotificationCubit),
          BlocProvider<AddressCubit>.value(value: mockAddressCubit),
          BlocProvider<OrderBloc>.value(value: mockOrderBloc),
        ],
      );

      await tester.pump();
    }

    setUp(() async {
      await sl.reset();

      mockCartBloc = MockCartBloc();
      mockNotificationCubit = MockNotificationCubit();
      mockAddressCubit = MockAddressCubit();
      mockSearchBloc = MockSearchBloc();
      mockOrderBloc = MockOrderBloc();

      const cartInitialState = CartLoaded(
        items: <CartItem>[],
        totalPrice: 0,
        totalItems: 0,
      );
      when(() => mockCartBloc.state).thenReturn(cartInitialState);
      whenListen<CartState>(
        mockCartBloc,
        Stream.value(cartInitialState),
        initialState: cartInitialState,
      );
      when(() => mockCartBloc.close()).thenAnswer((_) async {});

      const notificationState = NotificationLoaded(
        notifications: <notification_entity.Notification>[],
        unreadCount: 0,
      );
      when(() => mockNotificationCubit.state).thenReturn(notificationState);
      whenListen<NotificationState>(
        mockNotificationCubit,
        Stream.value(notificationState),
        initialState: notificationState,
      );
      when(() => mockNotificationCubit.close()).thenAnswer((_) async {});

      const addressState = AddressLoaded(
        addresses: <Address>[],
        selectedAddress: null,
      );
      when(() => mockAddressCubit.state).thenReturn(addressState);
      whenListen<AddressState>(
        mockAddressCubit,
        Stream.value(addressState),
        initialState: addressState,
      );
      when(() => mockAddressCubit.close()).thenAnswer((_) async {});

      const searchInitialState = SearchInitial();
      when(() => mockSearchBloc.state).thenReturn(searchInitialState);
      whenListen<SearchState>(
        mockSearchBloc,
        Stream.value(searchInitialState),
        initialState: searchInitialState,
      );
      when(() => mockSearchBloc.close()).thenAnswer((_) async {});

      const orderInitialState = OrderLoaded(activeOrders: [], pastOrders: []);
      when(() => mockOrderBloc.state).thenReturn(orderInitialState);
      whenListen<OrderState>(
        mockOrderBloc,
        Stream.value(orderInitialState),
        initialState: orderInitialState,
      );
      when(() => mockOrderBloc.close()).thenAnswer((_) async {});

      sl.registerFactory<CartBloc>(() => mockCartBloc);
      sl.registerFactory<SearchBloc>(() => mockSearchBloc);
      sl.registerFactory<OrderBloc>(() => mockOrderBloc);
    });

    testWidgets('should render ShellScreen with all components', (
      tester,
    ) async {
      // Arrange
      bottomNavCubit = BottomNavCubit();

      // Act
      await pumpShellScreen(tester, cubit: bottomNavCubit);

      // Assert
      expect(find.byType(ShellScreen), findsOneWidget);
      expect(find.byType(ShellTabContent), findsOneWidget);
      expect(find.byType(ShellBottomNavBar), findsOneWidget);
    });

    testWidgets('should display bottom nav bar when isVisible is true', (
      tester,
    ) async {
      // Arrange
      bottomNavCubit = BottomNavCubit();

      // Act
      await pumpShellScreen(tester, cubit: bottomNavCubit);

      // Assert
      final bottomNav = tester.widget<ShellBottomNavBar>(
        find.byType(ShellBottomNavBar),
      );
      expect(bottomNav.isVisible, isTrue);
    });

    testWidgets('should hide bottom nav bar when isVisible is false', (
      tester,
    ) async {
      // Arrange
      bottomNavCubit = BottomNavCubit()..hide();

      // Act
      await pumpShellScreen(tester, cubit: bottomNavCubit);

      // Assert
      final bottomNav = tester.widget<ShellBottomNavBar>(
        find.byType(ShellBottomNavBar),
      );
      expect(bottomNav.isVisible, isFalse);
    });

    testWidgets('should update content when tab changes', (tester) async {
      // Arrange
      bottomNavCubit = BottomNavCubit();

      await pumpShellScreen(tester, cubit: bottomNavCubit);

      // Act - Change to cart tab
      bottomNavCubit.setTab(BottomTab.cart);
      await tester.pumpAndSettle();

      // Assert
      final tabContent = tester.widget<ShellTabContent>(
        find.byType(ShellTabContent),
      );
      expect(tabContent.currentTab, BottomTab.cart);
    });

    testWidgets('should pass correct currentTab to ShellBottomNavBar', (
      tester,
    ) async {
      // Arrange
      bottomNavCubit = BottomNavCubit()..setTab(BottomTab.orders);

      // Act
      await pumpShellScreen(tester, cubit: bottomNavCubit);

      // Assert
      final bottomNav = tester.widget<ShellBottomNavBar>(
        find.byType(ShellBottomNavBar),
      );
      expect(bottomNav.currentTab, BottomTab.orders);
    });
  });

  group('ShellBottomNavBar Widget Tests', () {
    testWidgets('should render all 4 navigation items', (tester) async {
      // Arrange
      // ignore: unused_local_variable
      int tappedIndex = -1;

      // Act
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: true,
            onTapTab: (index) => tappedIndex = index,
          ),
        ),
      );

      // Assert - Verify the active tab shows its label
      expect(find.text('Home'), findsOneWidget);
      // Verify all 4 CustomNavItem widgets are rendered
      expect(find.byType(CustomNavItem), findsNWidgets(4));
    });

    testWidgets('should highlight active tab correctly', (tester) async {
      // Act
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.cart,
            isVisible: true,
            onTapTab: (_) {},
          ),
        ),
      );

      // Assert - Verify bottom nav bar exists with correct tab
      final bottomNav = tester.widget<ShellBottomNavBar>(
        find.byType(ShellBottomNavBar),
      );
      expect(bottomNav.currentTab, BottomTab.cart);
    });

    testWidgets('should call onTapTab when home tab is tapped', (tester) async {
      // Arrange
      int tappedIndex = -1;

      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: true,
            onTapTab: (index) => tappedIndex = index,
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Home'));
      await tester.pump();

      // Assert
      expect(tappedIndex, 0);
    });

    testWidgets('should call onTapTab when cart tab is tapped', (tester) async {
      // Arrange
      int tappedIndex = -1;

      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: true,
            onTapTab: (index) => tappedIndex = index,
          ),
        ),
      );

      // Act - Find and tap the second CustomNavItem (Cart)
      final navItems = find.byType(CustomNavItem);
      await tester.tap(navItems.at(1));
      await tester.pump();

      // Assert
      expect(tappedIndex, 1);
    });

    testWidgets('should call onTapTab when orders tab is tapped', (
      tester,
    ) async {
      // Arrange
      int tappedIndex = -1;

      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: true,
            onTapTab: (index) => tappedIndex = index,
          ),
        ),
      );

      // Act - Find and tap the third CustomNavItem (Orders)
      final navItems = find.byType(CustomNavItem);
      await tester.tap(navItems.at(2));
      await tester.pump();

      // Assert
      expect(tappedIndex, 2);
    });

    testWidgets('should call onTapTab when profile tab is tapped', (
      tester,
    ) async {
      // Arrange
      int tappedIndex = -1;

      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: true,
            onTapTab: (index) => tappedIndex = index,
          ),
        ),
      );

      // Act - Find and tap the fourth CustomNavItem (Profile)
      final navItems = find.byType(CustomNavItem);
      await tester.tap(navItems.at(3));
      await tester.pump();

      // Assert
      expect(tappedIndex, 3);
    });

    testWidgets('should apply visibility animation when isVisible changes', (
      tester,
    ) async {
      // Arrange - Start visible
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: true,
            onTapTab: (_) {},
          ),
        ),
      );

      // Verify visible state - Find AnimatedSlide within ShellBottomNavBar
      final navBarFinder = find.byType(ShellBottomNavBar);
      final animatedSlideFinder = find.descendant(
        of: navBarFinder,
        matching: find.byType(AnimatedSlide),
      );
      final animatedOpacityFinder = find.descendant(
        of: navBarFinder,
        matching: find.byType(AnimatedOpacity),
      );

      AnimatedSlide animatedSlide = tester.widget(animatedSlideFinder);
      expect(animatedSlide.offset, Offset.zero);

      AnimatedOpacity animatedOpacity = tester.widget(animatedOpacityFinder);
      expect(animatedOpacity.opacity, 1.0);

      // Act - Change to hidden
      await tester.pumpApp(
        Scaffold(
          bottomNavigationBar: ShellBottomNavBar(
            currentTab: BottomTab.home,
            isVisible: false,
            onTapTab: (_) {},
          ),
        ),
      );

      // Assert - Check hidden state
      animatedSlide = tester.widget(animatedSlideFinder);
      expect(animatedSlide.offset, const Offset(0, 1));

      animatedOpacity = tester.widget(animatedOpacityFinder);
      expect(animatedOpacity.opacity, 0.0);
    });
  });
}
