import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:spines/data/models/book.dart';
import 'package:spines/data/models/review.dart';

class BookLocalDataSource {
  List<Book> _books = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('📚 Loading books from JSON...');
      final String jsonString = await rootBundle.loadString(
        'assets/data/books.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final booksJson = jsonData['books'] as List;
      _books = booksJson.map((json) => Book.fromJson(json)).toList();

      final reviewsJson = jsonData['reviews'] as List? ?? [];
      final Map<String, List<Review>> reviewsByBook = {};

      for (var reviewJson in reviewsJson) {
        final review = Review.fromJson(reviewJson);
        final bookId = reviewJson['bookId'] as String;
        reviewsByBook.putIfAbsent(bookId, () => []).add(review);
      }

      for (var i = 0; i < _books.length; i++) {
        final book = _books[i];
        final bookReviews = reviewsByBook[book.id] ?? [];
        _books[i] = book.copyWith(reviews: bookReviews);
      }

      _isInitialized = true;
      debugPrint('✅ Loaded ${_books.length} books from JSON');
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading JSON: $e');
      debugPrint(stackTrace.toString());
      _books = [];
      _isInitialized = true;
    }
  }

  Future<void> addUserBook(Book book) async {
    if (!_isInitialized) {
      await initialize();
    }

    debugPrint(
      '📚 BookLocalDataSource.addUserBook: ${book.title} (${book.id})',
    );

    if (!_books.any((b) => b.id == book.id)) {
      _books.add(book);
      debugPrint('✅ Книга добавлена в _books, теперь всего: ${_books.length}');
      debugPrint('📚 Текущие ID в _books: ${_books.map((b) => b.id).toList()}');
    } else {
      debugPrint('⚠️ Книга уже есть в _books');
    }
  }

  Future<List<Book>> getBooks() async {
    if (!_isInitialized) {
      await initialize();
    }
    return List.unmodifiable(_books);
  }

  Future<Book?> getBookById(String id) async {
    if (!_isInitialized) {
      debugPrint(
        '⚠️ BookLocalDataSource не инициализирован, инициализируем...',
      );
      await initialize();
    }

    debugPrint('📚 BookLocalDataSource.getBookById для ID: $id');
    debugPrint('📚 Всего книг в _books: ${_books.length}');
    debugPrint('📚 ID в _books: ${_books.map((b) => b.id).toList()}');

    try {
      final book = _books.firstWhere((book) => book.id == id);
      debugPrint('✅ Найдена книга: ${book.title}');
      return book;
    } catch (e) {
      debugPrint('❌ Книга с ID $id не найдена в _books');
      return null;
    }
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _books.where((book) {
      return book.title.toLowerCase().contains(lowerQuery) ||
          book.author.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<String> getAllGenres() {
    final genres = <String>{};
    for (var book in _books) {
      genres.addAll(book.genres);
    }
    return genres.toList()..sort();
  }
}
