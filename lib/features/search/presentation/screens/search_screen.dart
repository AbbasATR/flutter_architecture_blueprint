import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_event.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/search_results_view.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/search_tabs.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/widgets/search_text_field.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;

/// Main search screen with search field and tabbed results
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<SearchBloc>().add(SearchTabChanged(_tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const SearchCleared());
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          SearchTabs(controller: _tabController),
          Expanded(child: SearchResultsView(tabController: _tabController)),
        ],
      ),
    );
  }

  /// Builds the app bar with search field
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.cs.surface,
      elevation: 0,
      leading: custom.FloatingActionButton(
        icon: IconsaxPlusLinear.undo,
        onTap: () => Navigator.pop(context),
      ),
      title: SearchTextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onSubmitted: _performSearch,
        onClear: _clearSearch,
      ),
    );
  }
}
