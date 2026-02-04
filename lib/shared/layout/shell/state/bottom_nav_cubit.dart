import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../bottom_tab.dart';

class BottomNavState extends Equatable {
  final BottomTab currentTab;
  final bool isVisible;

  const BottomNavState({required this.currentTab, required this.isVisible});

  factory BottomNavState.initial() =>
      const BottomNavState(currentTab: BottomTab.home, isVisible: true);

  BottomNavState copyWith({BottomTab? currentTab, bool? isVisible}) {
    return BottomNavState(
      currentTab: currentTab ?? this.currentTab,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [currentTab, isVisible];
}

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavState.initial());

  void setTab(BottomTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void show() {
    emit(state.copyWith(isVisible: true));
  }

  void hide() {
    emit(state.copyWith(isVisible: false));
  }

  void toggle() {
    emit(state.copyWith(isVisible: !state.isVisible));
  }
}
