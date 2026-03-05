import 'package:dartz/dartz.dart';
import '../../data/models/book.dart';
import '../../data/models/review.dart';

abstract class BookRepository {
  Future<Either<String, List<Book>>> getBooks();
  Future<Either<String, Book>> getBookById(String id);
  Future<Either<String, List<Book>>> getRecommendedBooks();
  Future<Either<String, List<Book>>> getPopularBooks();
  Future<Either<String, List<Book>>> getNewBooks();

  Future<Either<String, List<Book>>> getFavoriteBooks();
  Future<Either<String, void>> toggleFavorite(String bookId);

  Future<Either<String, List<Book>>> getShelfBooks();
  Future<Either<String, void>> addToShelf(String bookId);
  Future<Either<String, void>> removeFromShelf(String bookId);
  Future<Either<String, void>> updateProgress(String bookId, int page);

  Future<Either<String, void>> updateBookInfo({
    required String bookId,
    required String title,
    required String author,
    int? publicationYear,
    String? description,
  });

  Future<Either<String, List<Book>>> searchBooks(String query);

  Future<Either<String, void>> addReview(String bookId, Review review);
  Future<Either<String, List<Review>>> getReviews(String bookId);

  Future<void> syncFavorites();
  Future<void> syncShelf();
}
