import 'package:flutter/material.dart';

enum SortBy {
  title('Название'),
  author('Автор'),
  rating('Рейтинг'),
  year('Год'),
  pages('Страницы');

  final String label;
  const SortBy(this.label);
}

enum SortOrder {
  asc('По возрастанию'),
  desc('По убыванию');

  final String label;
  const SortOrder(this.label);
}

class FilterOptions {
  final String? searchQuery;
  final List<String> selectedGenres;
  final RangeValues? yearRange;
  final double? minRating;
  final SortBy sortBy;
  final SortOrder sortOrder;

  const FilterOptions({
    this.searchQuery,
    this.selectedGenres = const [],
    this.yearRange,
    this.minRating,
    this.sortBy = SortBy.title,
    this.sortOrder = SortOrder.asc,
  });

  FilterOptions copyWith({
    String? searchQuery,
    List<String>? selectedGenres,
    RangeValues? yearRange,
    double? minRating,
    SortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return FilterOptions(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      yearRange: yearRange ?? this.yearRange,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  bool get hasActiveFilters {
    return searchQuery != null ||
        selectedGenres.isNotEmpty ||
        yearRange != null ||
        minRating != null;
  }
}
