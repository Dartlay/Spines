import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spines/core/localization/s.dart';
import '../bloc/filter_bloc.dart';
import '../models/filter_model.dart';
import '../../../core/theme/app_colors.dart';

class FilterContent extends StatelessWidget {
  const FilterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchSection(context, state),
              const SizedBox(height: 24),
              _buildGenresSection(context, state),
              const SizedBox(height: 24),
              _buildYearSection(context, state),
              const SizedBox(height: 24),
              _buildRatingSection(context, state),
              const SizedBox(height: 24),
              _buildSortSection(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.tr.search, Icons.search),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: context.tr.searchHint,
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onChanged: (query) {
              context.read<FilterBloc>().add(UpdateSearchQuery(query));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenresSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.tr.genres, Icons.category),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.availableGenres.map((genre) {
            final isSelected = state.filters.selectedGenres.contains(genre);
            return GestureDetector(
              onTap: () {
                context.read<FilterBloc>().add(ToggleGenre(genre));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey[50],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.grey[200]!,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  genre,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildYearSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.tr.publicationYear, Icons.calendar_today),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              RangeSlider(
                values: state.filters.yearRange ?? state.availableYearRange,
                min: state.availableYearRange.start,
                max: state.availableYearRange.end,
                divisions:
                    (state.availableYearRange.end -
                            state.availableYearRange.start)
                        .toInt(),
                labels: RangeLabels(
                  state.filters.yearRange?.start.toString() ??
                      state.availableYearRange.start.toStringAsFixed(0),
                  state.filters.yearRange?.end.toString() ??
                      state.availableYearRange.end.toStringAsFixed(0),
                ),
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey[300],
                onChanged: (values) {
                  context.read<FilterBloc>().add(UpdateYearRange(values));
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildYearChip(
                    state.filters.yearRange?.start.toInt() ??
                        state.availableYearRange.start.toInt(),
                  ),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  _buildYearChip(
                    state.filters.yearRange?.end.toInt() ??
                        state.availableYearRange.end.toInt(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYearChip(int year) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        year.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.tr.minRating, Icons.star),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  value: state.filters.minRating ?? 0,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  activeColor: AppColors.primary,
                  inactiveColor: Colors.grey[300],
                  label: (state.filters.minRating ?? 0).toStringAsFixed(1),
                  onChanged: (value) {
                    context.read<FilterBloc>().add(UpdateMinRating(value));
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      (state.filters.minRating ?? 0).toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection(BuildContext context, FilterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context.tr.sort, Icons.sort),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonFormField<SortBy>(
                  value: state.filters.sortBy,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                  items: SortBy.values.map((sort) {
                    return DropdownMenuItem(
                      value: sort,
                      child: Text(
                        sort.label,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<FilterBloc>().add(ChangeSort(value));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  state.filters.sortOrder == SortOrder.asc
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  context.read<FilterBloc>().add(const ToggleSortOrder());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
