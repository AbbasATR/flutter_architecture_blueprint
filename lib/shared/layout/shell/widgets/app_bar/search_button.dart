import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter_architecture_blueprint/features/search/presentation/screens/search_screen.dart';
import 'package:flutter_architecture_blueprint/injection/injection_container.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';

/// Search button component for the shell app bar.
///
/// Displays a search icon that will navigate to search screen when tapped.
class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<SearchBloc>(),
              child: const SearchScreen(),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: context.units.w(40),
        height: context.units.w(40),
        decoration: BoxDecoration(
          border:
              Border.all(color: context.cs.outline.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(IconsaxPlusLinear.search_normal, size: context.units.w(20)),
      ),
    );
  }
}
