import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spines/core/services/review_service.dart';
import 'package:spines/data/models/book.dart';
import 'package:spines/data/models/review.dart';
import '../../../domain/repositories/book_repository.dart';

part 'book_details_event.dart';
part 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final BookRepository _repository;

  BookDetailsBloc({required BookRepository repository})
    : _repository = repository,
      super(const BookDetailsState()) {
    on<LoadBookDetails>(_onLoadBookDetails);
    on<ToggleFavorite>(_onToggleFavorite);
    on<AddToShelf>(_onAddToShelf);
    on<AddReview>(_onAddReview);
  }

  Future<void> _onLoadBookDetails(
    LoadBookDetails event,
    Emitter<BookDetailsState> emit,
  ) async {
    emit(state.copyWith(status: BookDetailsStatus.loading));

    try {
      final bookResult = await _repository.getBookById(event.bookId);
      final shelfResult = await _repository.getShelfBooks();

      await bookResult.fold(
        (error) async {
          emit(
            state.copyWith(
              status: BookDetailsStatus.error,
              errorMessage: error,
            ),
          );
        },
        (book) async {
          bool isOnShelf = false;
          await shelfResult.fold(
            (error) => null,
            (shelfBooks) => isOnShelf = shelfBooks.any((b) => b.id == book.id),
          );

          final savedReviews = await ReviewService.loadReviews(book.id);
          final allReviews = [...book.reviews, ...savedReviews];

          final uniqueReviews = allReviews
              .fold<Map<String, Review>>({}, (map, review) {
                map[review.id] = review;
                return map;
              })
              .values
              .toList();

          final favoritesResult = await _repository.getFavoriteBooks();
          bool isFavorite = false;
          await favoritesResult.fold(
            (error) => null,
            (favorites) => isFavorite = favorites.any((b) => b.id == book.id),
          );

          emit(
            state.copyWith(
              status: BookDetailsStatus.loaded,
              book: book.copyWith(
                reviews: uniqueReviews,
                isFavorite: isFavorite,
              ),
              isOnShelf: isOnShelf,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BookDetailsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<BookDetailsState> emit,
  ) async {
    try {
      await _repository.toggleFavorite(event.bookId);

      final favoritesResult = await _repository.getFavoriteBooks();
      bool isFavorite = false;
      await favoritesResult.fold(
        (error) => null,
        (favorites) => isFavorite = favorites.any((b) => b.id == event.bookId),
      );

      if (state.book != null) {
        final updatedBook = state.book!.copyWith(isFavorite: isFavorite);
        emit(state.copyWith(book: updatedBook));
      }
    } catch (e) {}
  }

  Future<void> _onAddToShelf(
    AddToShelf event,
    Emitter<BookDetailsState> emit,
  ) async {
    try {
      await _repository.addToShelf(event.bookId);
      emit(state.copyWith(isOnShelf: true));
    } catch (e) {}
  }

  Future<void> _onAddReview(
    AddReview event,
    Emitter<BookDetailsState> emit,
  ) async {
    if (state.book == null) return;

    try {
      final newReview = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        userName: 'Вы',
        userAvatar: null,
        rating: event.rating,
        comment: event.comment,
        date: DateTime.now(),
        likes: 0,
      );

      await ReviewService.saveReview(event.bookId, newReview);

      final updatedReviews = [...state.book!.reviews, newReview];
      final updatedBook = state.book!.copyWith(reviews: updatedReviews);

      emit(state.copyWith(book: updatedBook));
    } catch (e) {}
  }
}
