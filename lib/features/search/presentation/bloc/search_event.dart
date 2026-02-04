import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Event to perform search
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search results
class SearchCleared extends SearchEvent {
  const SearchCleared();
}

/// Event to switch between tabs
class SearchTabChanged extends SearchEvent {
  final int tabIndex;

  const SearchTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}
