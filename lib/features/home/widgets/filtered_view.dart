import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/book.dart';
import '../../../core/theme/app_colors.dart';
import '../../filters/bloc/filter_bloc.dart';
import 'book_card.dart';

class FilteredView extends StatelessWidget {
  final FilterState filterState;
  final Function(Book) onBookTap;

  const FilteredView({
    super.key,
    required this.filterState,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: FilterBar(filterState: filterState)),
        if (filterState.filteredBooks.isEmpty)
          const SliverFillRemaining(child: EmptyFilterResults())
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final book = filterState.filteredBooks[index];
                return BookCard(book: book, isCompact: false, onTap: onBookTap);
              }, childCount: filterState.filteredBooks.length),
            ),
          ),
      ],
    );
  }
}

class FilterBar extends StatelessWidget {
  final FilterState filterState;

  const FilterBar({super.key, required this.filterState});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.filter_list_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Найдено книг: ${filterState.filteredBooks.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (filterState.hasActiveFilters) ...[
                  const SizedBox(height: 4),
                  Text(
                    _getActiveFiltersText(filterState),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton.icon(
              onPressed: () {
                context.read<FilterBloc>().add(const ResetFilters());
              },
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Сбросить'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveFiltersText(FilterState state) {
    final List<String> filters = [];

    if (state.filters.searchQuery != null &&
        state.filters.searchQuery!.isNotEmpty) {
      filters.add('поиск: "${state.filters.searchQuery}"');
    }

    if (state.filters.selectedGenres.isNotEmpty) {
      filters.add('жанры: ${state.filters.selectedGenres.length}');
    }

    if (state.filters.yearRange != null) {
      filters.add(
        'годы: ${state.filters.yearRange!.start.toInt()}-${state.filters.yearRange!.end.toInt()}',
      );
    }

    if (state.filters.minRating != null) {
      filters.add('рейтинг ≥ ${state.filters.minRating}');
    }

    return 'Фильтры: ${filters.join(' • ')}';
  }
}

class EmptyFilterResults extends StatelessWidget {
  const EmptyFilterResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_alt_off,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ничего не найдено',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Попробуйте изменить параметры фильтрации',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
