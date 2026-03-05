import 'package:flutter/widgets.dart';
import 'package:spines/core/services/storage_service.dart';
import 'package:spines/data/models/book.dart';

class ShelfLocalDataSource {
  List<Book> _shelf = [];

  Future<void> saveShelf(List<Book> shelf) async {
    debugPrint(
      '📚 shelf_local_data_source.saveShelf - НАЧАЛО, книг: ${shelf.length}',
    );
    await StorageService.saveShelf(shelf);
    _shelf = List.from(shelf);
    debugPrint('✅ shelf_local_data_source.saveShelf - КОНЕЦ');
  }

  Future<List<Book>> loadShelf() async {
    debugPrint('📚 shelf_local_data_source.loadShelf() - НАЧАЛО');
    _shelf = await StorageService.loadShelf();
    debugPrint('📚 Загружено ${_shelf.length} книг из StorageService');
    debugPrint('📚 ID: ${_shelf.map((b) => b.id).toList()}');
    return List.unmodifiable(_shelf);
  }

  List<Book> getShelf() => List.unmodifiable(_shelf);

  Future<void> addToShelf(Book book) async {
    debugPrint(
      '📚 shelf_local_data_source.addToShelf - НАЧАЛО для книги ${book.id}',
    );
    debugPrint('📚 filePath книги: ${book.filePath}');

    if (!_shelf.any((b) => b.id == book.id)) {
      _shelf.add(book);
      debugPrint('✅ Книга добавлена в _shelf, теперь ${_shelf.length} книг');
      debugPrint('📚 filePath сохранен: ${book.filePath}');
      await saveShelf(_shelf);
    } else {
      debugPrint('⚠️ Книга уже есть на полке');
    }
  }

  Future<void> removeFromShelf(String bookId) async {
    _shelf.removeWhere((b) => b.id == bookId);
    await saveShelf(_shelf);
  }

  Future<void> updateBook(Book updatedBook) async {
    final index = _shelf.indexWhere((b) => b.id == updatedBook.id);
    if (index != -1) {
      _shelf[index] = updatedBook;
      await saveShelf(_shelf);
    }
  }

  Future<void> updateProgress(String bookId, int page) async {
    final index = _shelf.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final book = _shelf[index];
      _shelf[index] = book.copyWith(currentPage: page);
      await saveShelf(_shelf);
      await StorageService.saveProgress(bookId, page);
    }
  }
}
