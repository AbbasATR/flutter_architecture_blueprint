import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_item.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/entities/search_supplier.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no search performed yet
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Loading state - search in progress
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Loaded state - search results available
class SearchLoaded extends SearchState {
  final List<SearchSupplier> suppliers;
  final List<SearchItem> items;
  final String query;
  final int currentTabIndex;

  const SearchLoaded({
    required this.suppliers,
    required this.items,
    required this.query,
    this.currentTabIndex = 0,
  });

  @override
  List<Object?> get props => [suppliers, items, query, currentTabIndex];

  SearchLoaded copyWith({
    List<SearchSupplier>? suppliers,
    List<SearchItem>? items,
    String? query,
    int? currentTabIndex,
  }) {
    return SearchLoaded(
      suppliers: suppliers ?? this.suppliers,
      items: items ?? this.items,
      query: query ?? this.query,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

/// Error state - search failed
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
