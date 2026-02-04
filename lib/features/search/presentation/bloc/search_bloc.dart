import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_items.dart';
import 'package:flutter_architecture_blueprint/features/search/domain/usecases/search_suppliers.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchItems searchItems;
  final SearchSuppliers searchSuppliers;

  SearchBloc({required this.searchItems, required this.searchSuppliers})
    : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchCleared>(_onSearchCleared);
    on<SearchTabChanged>(_onSearchTabChanged);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    // Perform both searches in parallel
    final suppliersResult = await searchSuppliers(
      SearchSuppliersParams(query: query),
    );
    final itemsResult = await searchItems(SearchItemsParams(query: query));

    // Handle results
    suppliersResult.fold(
      (failure) {
        emit(SearchError(failure.message));
      },
      (suppliers) {
        itemsResult.fold(
          (failure) {
            emit(SearchError(failure.message));
          },
          (items) {
            emit(
              SearchLoaded(
                suppliers: suppliers,
                items: items,
                query: query,
                currentTabIndex: 0,
              ),
            );
          },
        );
      },
    );
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }

  void _onSearchTabChanged(SearchTabChanged event, Emitter<SearchState> emit) {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    }
  }
}
