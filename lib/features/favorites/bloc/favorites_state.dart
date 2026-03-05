part of 'favorites_bloc.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<Book> books;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.books = const [],
    this.errorMessage,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Book>? books,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage];
}
