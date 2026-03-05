import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spines/core/services/temp_storage.dart';
import 'package:spines/data/datasources/local/book_local_data_source.dart';
import 'package:spines/data/datasources/local/favorites_local_data_source.dart';
import 'package:spines/data/datasources/local/shelf_local_data_source.dart';
import 'package:spines/data/datasources/local/review_local_data_source.dart';
import 'package:spines/data/models/book.dart';
import 'package:spines/data/models/review.dart';
import '../../domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookLocalDataSource _bookDataSource;
  final FavoritesLocalDataSource _favoritesDataSource;
  final ShelfLocalDataSource _shelfDataSource;
  final ReviewLocalDataSource _reviewDataSource;

  BookRepositoryImpl({
    required BookLocalDataSource bookDataSource,
    required FavoritesLocalDataSource favoritesDataSource,
    required ShelfLocalDataSource shelfDataSource,
    required ReviewLocalDataSource reviewDataSource,
  }) : _bookDataSource = bookDataSource,
       _favoritesDataSource = favoritesDataSource,
       _shelfDataSource = shelfDataSource,
       _reviewDataSource = reviewDataSource {}

  @override
  Future<Either<String, List<Book>>> getBooks() async {
    try {
      final books = await _bookDataSource.getBooks();
      return Right(books);
    } catch (e) {
      return Left('Failed to load books: $e');
    }
  }

  @override
  Future<Either<String, void>> updateBookInfo({
    required String bookId,
    required String title,
    required String author,
    int? publicationYear,
    String? description,
  }) async {
    try {
      final allBooks = await _bookDataSource.getBooks();
      final shelfBooks = _shelfDataSource.getShelf();

      final bookIndex = allBooks.indexWhere((b) => b.id == bookId);
      if (bookIndex != -1) {}

      final shelfIndex = shelfBooks.indexWhere((b) => b.id == bookId);
      if (shelfIndex != -1) {
        final oldBook = shelfBooks[shelfIndex];
        final updatedBook = oldBook.copyWith(
          title: title,
          author: author,
          publicationYear: publicationYear ?? oldBook.publicationYear,
          description: description ?? oldBook.description,
        );

        await _updateShelfBook(bookId, updatedBook);
      }
      return const Right(null);
    } catch (e) {
      return Left('Failed to update book info: $e');
    }
  }

  Future<void> _updateShelfBook(String bookId, Book updatedBook) async {
    final shelfBooks = _shelfDataSource.getShelf();
    final index = shelfBooks.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final newShelf = List<Book>.from(shelfBooks);
      newShelf[index] = updatedBook;
      await _shelfDataSource.saveShelf(newShelf);
    }
  }

  @override
  Future<Either<String, Book>> getBookById(String id) async {
    debugPrint('📚 BookRepositoryImpl.getBookById вызван для ID: $id');

    try {
      final book = await _bookDataSource.getBookById(id);
      debugPrint(
        '📚 bookDataSource вернул: ${book != null ? book.title : 'null'}',
      );

      if (book != null) {
        final reviews = await _reviewDataSource.loadReviews(id);
        final bookWithReviews = book.copyWith(reviews: reviews);
        debugPrint(
          '✅ Книга найдена: ${book.title}, filePath: ${book.filePath}',
        );
        return Right(bookWithReviews);
      }

      debugPrint('❌ Книга не найдена в bookDataSource');
      return Left('Book not found');
    } catch (e) {
      debugPrint('❌ Ошибка: $e');
      return Left('Failed to load book: $e');
    }
  }

  @override
  Future<Either<String, List<Book>>> getRecommendedBooks() async {
    try {
      final books = await _bookDataSource.getBooks();
      return Right(books.where((b) => b.rating >= 4.8).take(5).toList());
    } catch (e) {
      return Left('Failed to load recommended books: $e');
    }
  }

  @override
  Future<Either<String, List<Book>>> getPopularBooks() async {
    try {
      final books = await _bookDataSource.getBooks();
      final sorted = List<Book>.from(books)
        ..sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
      return Right(sorted.take(5).toList());
    } catch (e) {
      return Left('Failed to load popular books: $e');
    }
  }

  @override
  Future<Either<String, List<Book>>> getNewBooks() async {
    try {
      final books = await _bookDataSource.getBooks();
      return Right(books.where((b) => b.isNew).toList());
    } catch (e) {
      return Left('Failed to load new books: $e');
    }
  }

  @override
  Future<Either<String, List<Book>>> getFavoriteBooks() async {
    try {
      final allBooks = await _bookDataSource.getBooks();
      final shelfBooks = _shelfDataSource.getShelf();
      final favorites = await _favoritesDataSource.loadFavorites(
        allBooks,
        shelfBooks,
      );
      return Right(favorites);
    } catch (e) {
      return Left('Failed to load favorite books: $e');
    }
  }

  @override
  Future<Either<String, List<Book>>> getShelfBooks() async {
    try {
      final shelf = await _shelfDataSource.loadShelf();
      return Right(shelf);
    } catch (e) {
      return Left('Failed to load shelf books: $e');
    }
  }

  @override
  Future<Either<String, void>> toggleFavorite(String bookId) async {
    try {
      final allBooks = await _bookDataSource.getBooks();
      final shelfBooks = _shelfDataSource.getShelf();

      Book? book;
      try {
        book = allBooks.firstWhere((b) => b.id == bookId);
      } catch (e) {
        try {
          book = shelfBooks.firstWhere((b) => b.id == bookId);
        } catch (e) {
          book = null;
        }
      }

      if (book == null) {
        return Left('Book not found');
      }

      final currentFavoriteIds = await _favoritesDataSource.loadFavoriteIds();

      if (currentFavoriteIds.contains(bookId)) {
        final newIds = currentFavoriteIds.where((id) => id != bookId).toList();
        await _saveFavoriteIds(newIds);
      } else {
        final newIds = [...currentFavoriteIds, bookId];
        await _saveFavoriteIds(newIds);
      }

      return const Right(null);
    } catch (e) {
      return Left('Failed to toggle favorite: $e');
    }
  }

  Future<void> _saveFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_favorites', ids);
  }

  @override
  Future<Either<String, void>> addToShelf(String bookId) async {
    debugPrint('📚 BookRepositoryImpl.addToShelf вызван для ID: $bookId');

    try {
      final allBooks = await _bookDataSource.getBooks();
      final shelfBooks = _shelfDataSource.getShelf();

      debugPrint('📚 Всего книг в allBooks: ${allBooks.length}');
      debugPrint('📚 Книг на полке до добавления: ${shelfBooks.length}');
      Book? book;
      try {
        book = allBooks.firstWhere((b) => b.id == bookId);
        debugPrint('✅ Книга найдена в allBooks: ${book?.title}');
      } catch (e) {
        debugPrint('❌ Книга не найдена в allBooks');
      }
      if (book == null) {
        try {
          book = shelfBooks.firstWhere((b) => b.id == bookId);
          debugPrint('✅ Книга найдена на полке: ${book?.title}');
        } catch (e) {
          debugPrint('❌ Книга не найдена на полке');
        }
      }

      if (book == null) {
        debugPrint('📚 Книга не найдена, создаем новую с ID: $bookId');

        final filePath = await TempStorage.getBookPath(bookId);
        debugPrint('📚 Путь к файлу из TempStorage: $filePath');

        book = Book(
          id: bookId,
          title: 'Загруженная книга ${bookId.substring(bookId.length - 6)}',
          author: 'Неизвестный автор',
          description: 'Книга, загруженная пользователем',
          rating: 0.0,
          pages: 100,
          filePath: filePath,
          genres: [],
          publicationYear: DateTime.now().year,
          language: 'Русский',
          isNew: true,
        );
        debugPrint('✅ Создана новая книга: ${book.title}');

        await _bookDataSource.addUserBook(book);
        debugPrint('✅ Книга добавлена в BookLocalDataSource');
      }

      debugPrint('📚 Добавляем книгу ${book.id} на полку');
      await _shelfDataSource.addToShelf(book);
      debugPrint('✅ Книга добавлена через shelfDataSource');

      return const Right(null);
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      return Left('Failed to add to shelf: $e');
    }
  }

  @override
  Future<Either<String, void>> removeFromShelf(String bookId) async {
    try {
      await _shelfDataSource.removeFromShelf(bookId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to remove from shelf: $e');
    }
  }

  @override
  Future<Either<String, void>> updateProgress(String bookId, int page) async {
    try {
      await _shelfDataSource.updateProgress(bookId, page);
      return const Right(null);
    } catch (e) {
      return Left('Failed to update progress: $e');
    }
  }

  @override
  Future<Either<String, List<Book>>> searchBooks(String query) async {
    try {
      final books = await _bookDataSource.getBooks();
      return Right(_bookDataSource.searchBooks(query));
    } catch (e) {
      return Left('Failed to search books: $e');
    }
  }

  @override
  Future<Either<String, void>> addReview(String bookId, Review review) async {
    try {
      await _reviewDataSource.saveReview(bookId, review);
      return const Right(null);
    } catch (e) {
      return Left('Failed to add review: $e');
    }
  }

  @override
  Future<Either<String, List<Review>>> getReviews(String bookId) async {
    try {
      final reviews = await _reviewDataSource.loadReviews(bookId);
      return Right(reviews);
    } catch (e) {
      return Left('Failed to load reviews: $e');
    }
  }

  @override
  Future<void> syncFavorites() async {
    final allBooks = await _bookDataSource.getBooks();
    final shelfBooks = _shelfDataSource.getShelf();
    await _favoritesDataSource.loadFavorites(allBooks, shelfBooks);
  }

  @override
  Future<void> syncShelf() async {
    await _shelfDataSource.loadShelf();
  }
}
