import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/state/bottom_nav_cubit.dart';
import 'package:flutter_architecture_blueprint/shared/layout/shell/bottom_tab.dart';

void main() {
  late BottomNavCubit bottomNavCubit;

  setUp(() {
    bottomNavCubit = BottomNavCubit();
  });

  tearDown(() {
    bottomNavCubit.close();
  });

  test(
    'initial state should be BottomNavState with home tab and visible true',
    () {
      expect(
        bottomNavCubit.state,
        equals(
          const BottomNavState(currentTab: BottomTab.home, isVisible: true),
        ),
      );
    },
  );

  group('setTab', () {
    blocTest<BottomNavCubit, BottomNavState>(
      'should emit state with cart tab when setTab(cart) is called',
      build: () => bottomNavCubit,
      act: (cubit) => cubit.setTab(BottomTab.cart),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.cart, isVisible: true),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should emit state with orders tab when setTab(orders) is called',
      build: () => bottomNavCubit,
      act: (cubit) => cubit.setTab(BottomTab.orders),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.orders, isVisible: true),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should emit state with profile tab when setTab(profile) is called',
      build: () => bottomNavCubit,
      act: (cubit) => cubit.setTab(BottomTab.profile),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.profile, isVisible: true),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should emit state with home tab when setTab(home) is called',
      build: () => bottomNavCubit,
      act: (cubit) => cubit.setTab(BottomTab.home),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.home, isVisible: true),
      ],
    );
  });

  group('visibility', () {
    blocTest<BottomNavCubit, BottomNavState>(
      'should emit state with isVisible=false when hide() is called',
      build: () => bottomNavCubit,
      act: (cubit) => cubit.hide(),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.home, isVisible: false),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should emit state with isVisible=true when show() is called',
      build: () => bottomNavCubit,
      seed: () =>
          const BottomNavState(currentTab: BottomTab.home, isVisible: false),
      act: (cubit) => cubit.show(),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.home, isVisible: true),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should toggle isVisible from true to false when toggle() is called',
      build: () => bottomNavCubit,
      act: (cubit) => cubit.toggle(),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.home, isVisible: false),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should toggle isVisible from false to true when toggle() is called',
      build: () => bottomNavCubit,
      seed: () =>
          const BottomNavState(currentTab: BottomTab.home, isVisible: false),
      act: (cubit) => cubit.toggle(),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.home, isVisible: true),
      ],
    );
  });

  group('combined operations', () {
    blocTest<BottomNavCubit, BottomNavState>(
      'should maintain visibility state when changing tabs',
      build: () => bottomNavCubit,
      seed: () =>
          const BottomNavState(currentTab: BottomTab.home, isVisible: false),
      act: (cubit) => cubit.setTab(BottomTab.cart),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.cart, isVisible: false),
      ],
    );

    blocTest<BottomNavCubit, BottomNavState>(
      'should maintain current tab when changing visibility',
      build: () => bottomNavCubit,
      seed: () =>
          const BottomNavState(currentTab: BottomTab.profile, isVisible: true),
      act: (cubit) => cubit.hide(),
      expect: () => [
        const BottomNavState(currentTab: BottomTab.profile, isVisible: false),
      ],
    );
  });
}
