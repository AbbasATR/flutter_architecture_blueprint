import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_state.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/items_list.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/search_empty_state.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/suppliers_list.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';

/// Widget that handles displaying search results based on state
class SearchResultsView extends StatelessWidget {
  final TabController tabController;

  const SearchResultsView({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return SearchEmptyState(
            icon: IconsaxPlusLinear.search_normal_1,
            message: l10n.searchStartSearching,
          );
        }

        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchError) {
          return SearchEmptyState(
            icon: IconsaxPlusLinear.danger,
            message: state.message,
            isError: true,
          );
        }

        if (state is SearchLoaded) {
          return TabBarView(
            controller: tabController,
            children: [
              SuppliersList(suppliers: state.suppliers),
              ItemsList(items: state.items),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
