import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spines/data/models/book.dart';
import 'package:spines/features/filters/models/filter_model.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState.initial()) {
    on<InitializeFilters>(_onInitializeFilters);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<ToggleGenre>(_onToggleGenre);
    on<UpdateYearRange>(_onUpdateYearRange);
    on<UpdateMinRating>(_onUpdateMinRating);
    on<ChangeSort>(_onChangeSort);
    on<ToggleSortOrder>(_onToggleSortOrder);
    on<ResetFilters>(_onResetFilters);
    on<ApplyFilters>(_onApplyFilters);
  }

  void _onInitializeFilters(
    InitializeFilters event,
    Emitter<FilterState> emit,
  ) {
    final allGenres =
        event.allBooks.expand((book) => book.genres).toSet().toList()..sort();

    final years = event.allBooks.map((b) => b.publicationYear).toList();
    final minYear = years.reduce((a, b) => a < b ? a : b);
    final maxYear = years.reduce((a, b) => a > b ? a : b);
    final filtered = _applyFilters(event.allBooks, state.filters);

    emit(
      state.copyWith(
        availableGenres: allGenres,
        availableYearRange: RangeValues(minYear.toDouble(), maxYear.toDouble()),
        filteredBooks: filtered,
        isInitialized: true,
      ),
    );
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<FilterState> emit,
  ) {
    final newFilters = state.filters.copyWith(searchQuery: event.query);
    _updateWithFilters(newFilters, emit);
  }

  void _onToggleGenre(ToggleGenre event, Emitter<FilterState> emit) {
    final currentGenres = state.filters.selectedGenres;
    final newGenres = currentGenres.contains(event.genre)
        ? currentGenres.where((g) => g != event.genre).toList()
        : [...currentGenres, event.genre];

    final newFilters = state.filters.copyWith(selectedGenres: newGenres);
    _updateWithFilters(newFilters, emit);
  }

  void _onUpdateYearRange(UpdateYearRange event, Emitter<FilterState> emit) {
    final newFilters = state.filters.copyWith(yearRange: event.range);
    _updateWithFilters(newFilters, emit);
  }

  void _onUpdateMinRating(UpdateMinRating event, Emitter<FilterState> emit) {
    final newFilters = state.filters.copyWith(minRating: event.rating);
    _updateWithFilters(newFilters, emit);
  }

  void _onChangeSort(ChangeSort event, Emitter<FilterState> emit) {
    final newFilters = state.filters.copyWith(
      sortBy: event.sortBy,
      sortOrder: event.sortOrder ?? state.filters.sortOrder,
    );
    _updateWithFilters(newFilters, emit);
  }

  void _onToggleSortOrder(ToggleSortOrder event, Emitter<FilterState> emit) {
    final newOrder = state.filters.sortOrder == SortOrder.asc
        ? SortOrder.desc
        : SortOrder.asc;
    final newFilters = state.filters.copyWith(sortOrder: newOrder);
    _updateWithFilters(newFilters, emit);
  }

  void _onResetFilters(ResetFilters event, Emitter<FilterState> emit) {
    final newFilters = const FilterOptions();
    _updateWithFilters(newFilters, emit);
  }

  void _onApplyFilters(ApplyFilters event, Emitter<FilterState> emit) {
    final filtered = _applyFilters(event.books, state.filters);
    emit(state.copyWith(filteredBooks: filtered));
  }

  void _updateWithFilters(FilterOptions newFilters, Emitter<FilterState> emit) {
    emit(state.copyWith(filters: newFilters));
  }

  List<Book> _applyFilters(List<Book> books, FilterOptions filters) {
    return books.where((book) {
      if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
        final query = filters.searchQuery!.toLowerCase();
        if (!book.title.toLowerCase().contains(query) &&
            !book.author.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (filters.selectedGenres.isNotEmpty) {
        if (!book.genres.any(
          (genre) => filters.selectedGenres.contains(genre),
        )) {
          return false;
        }
      }

      if (filters.yearRange != null) {
        if (book.publicationYear < filters.yearRange!.start ||
            book.publicationYear > filters.yearRange!.end) {
          return false;
        }
      }

      if (filters.minRating != null) {
        if (book.rating < filters.minRating!) {
          return false;
        }
      }

      return true;
    }).toList()..sort((a, b) {
      int comparison;
      switch (filters.sortBy) {
        case SortBy.title:
          comparison = a.title.compareTo(b.title);
          break;
        case SortBy.author:
          comparison = a.author.compareTo(b.author);
          break;
        case SortBy.rating:
          comparison = a.rating.compareTo(b.rating);
          break;
        case SortBy.year:
          comparison = a.publicationYear.compareTo(b.publicationYear);
          break;
        case SortBy.pages:
          comparison = a.pages.compareTo(b.pages);
          break;
      }
      return filters.sortOrder == SortOrder.asc ? comparison : -comparison;
    });
  }
}
