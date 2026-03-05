part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class InitializeFilters extends FilterEvent {
  final List<Book> allBooks;

  const InitializeFilters(this.allBooks);

  @override
  List<Object?> get props => [allBooks];
}

class UpdateSearchQuery extends FilterEvent {
  final String query;

  const UpdateSearchQuery(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleGenre extends FilterEvent {
  final String genre;

  const ToggleGenre(this.genre);

  @override
  List<Object?> get props => [genre];
}

class UpdateYearRange extends FilterEvent {
  final RangeValues range;

  const UpdateYearRange(this.range);

  @override
  List<Object?> get props => [range];
}

class UpdateMinRating extends FilterEvent {
  final double rating;

  const UpdateMinRating(this.rating);

  @override
  List<Object?> get props => [rating];
}

class ChangeSort extends FilterEvent {
  final SortBy sortBy;
  final SortOrder? sortOrder;

  const ChangeSort(this.sortBy, [this.sortOrder]);

  @override
  List<Object?> get props => [sortBy, sortOrder];
}

class ToggleSortOrder extends FilterEvent {
  const ToggleSortOrder();
}

class ResetFilters extends FilterEvent {
  const ResetFilters();
}

class ApplyFilters extends FilterEvent {
  final List<Book> books;

  const ApplyFilters(this.books);

  @override
  List<Object?> get props => [books];
}
