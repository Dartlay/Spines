part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final FilterOptions filters;
  final List<Book> filteredBooks;
  final List<String> availableGenres;
  final RangeValues availableYearRange;
  final bool isInitialized;

  const FilterState({
    required this.filters,
    required this.filteredBooks,
    required this.availableGenres,
    required this.availableYearRange,
    this.isInitialized = false,
  });

  factory FilterState.initial() {
    return FilterState(
      filters: const FilterOptions(),
      filteredBooks: [],
      availableGenres: [],
      availableYearRange: const RangeValues(1900, 2025),
      isInitialized: false,
    );
  }

  FilterState copyWith({
    FilterOptions? filters,
    List<Book>? filteredBooks,
    List<String>? availableGenres,
    RangeValues? availableYearRange,
    bool? isInitialized,
  }) {
    return FilterState(
      filters: filters ?? this.filters,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      availableGenres: availableGenres ?? this.availableGenres,
      availableYearRange: availableYearRange ?? this.availableYearRange,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  bool get hasActiveFilters => filters.hasActiveFilters;

  @override
  List<Object?> get props => [
    filters,
    filteredBooks,
    availableGenres,
    availableYearRange,
    isInitialized,
  ];
}
