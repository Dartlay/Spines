import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spines/data/models/book.dart';

class FavoritesLocalDataSource {
  static const String _favoritesKey = 'user_favorites';
  List<Book> _favorites = [];

  Future<void> saveFavorites(List<Book> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesIds = favorites.map((b) => b.id).toList();
      await prefs.setStringList(_favoritesKey, favoritesIds);
      _favorites = List.from(favorites);
    } catch (e) {}
  }

  Future<List<String>> loadFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Book>> loadFavorites(
    List<Book> allBooks,
    List<Book> shelfBooks,
  ) async {
    try {
      final favoritesIds = await loadFavoriteIds();
      final favorites = <Book>[];

      for (final bookId in favoritesIds) {
        Book? book = allBooks.firstWhere(
          (b) => b.id == bookId,
          orElse: () => null as Book,
        );

        // ignore: dead_code
        if (book == null) {
          book = shelfBooks.firstWhere(
            (b) => b.id == bookId,
            orElse: () => null as Book,
          );
        }

        if (book != null) {
          favorites.add(book);
        }
      }

      _favorites = favorites;

      return favorites;
    } catch (e) {
      return [];
    }
  }

  List<Book> getFavorites() => List.unmodifiable(_favorites);

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
    _favorites.clear();
  }
}
