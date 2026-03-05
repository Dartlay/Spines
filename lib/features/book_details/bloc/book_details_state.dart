part of 'book_details_bloc.dart';

enum BookDetailsStatus { initial, loading, loaded, error }

class BookDetailsState extends Equatable {
  final BookDetailsStatus status;
  final Book? book;
  final bool isOnShelf;
  final String? errorMessage;

  const BookDetailsState({
    this.status = BookDetailsStatus.initial,
    this.book,
    this.isOnShelf = false,
    this.errorMessage,
  });

  BookDetailsState copyWith({
    BookDetailsStatus? status,
    Book? book,
    bool? isOnShelf,
    String? errorMessage,
  }) {
    return BookDetailsState(
      status: status ?? this.status,
      book: book ?? this.book,
      isOnShelf: isOnShelf ?? this.isOnShelf,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, book, isOnShelf, errorMessage];
}
