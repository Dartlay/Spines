import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/features/filters/widgets/filter_bottom_bar.dart';
import '../bloc/filter_bloc.dart';
import '../widgets/filter_content.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/app_routes.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.tr.filters,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<FilterBloc>().add(const ResetFilters());
            },
            child: Text(
              context.tr.reset,
              style: TextStyle(color: AppColors.primary, fontSize: 16),
            ),
          ),
        ],
      ),
      body: const FilterContent(),
      bottomNavigationBar: const FilterBottomBar(),
    );
  }
}
