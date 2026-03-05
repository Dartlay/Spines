part of 'book_details_bloc.dart';

abstract class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();
}

class LoadBookDetails extends BookDetailsEvent {
  final String bookId;

  const LoadBookDetails(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class ToggleFavorite extends BookDetailsEvent {
  final String bookId;

  const ToggleFavorite(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class AddToShelf extends BookDetailsEvent {
  final String bookId;

  const AddToShelf(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class AddReview extends BookDetailsEvent {
  final String bookId;
  final double rating;
  final String comment;

  const AddReview({
    required this.bookId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [bookId, rating, comment];
}
