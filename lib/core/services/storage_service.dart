import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spines/data/models/book.dart';

class StorageService {
  static const String _shelfKey = 'user_shelf';
  static const String _progressKey = 'reading_progress';

  static Future<void> saveShelf(List<Book> books) async {
    debugPrint('💾 StorageService.saveShelf - НАЧАЛО, книг: ${books.length}');
    debugPrint('📚 Сохраняемые ID: ${books.map((b) => b.id).toList()}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = books.map((b) => json.encode(b.toJson())).toList();
      await prefs.setStringList(_shelfKey, booksJson);

      // Проверяем, что сохранилось
      final saved = prefs.getStringList(_shelfKey) ?? [];
      debugPrint('✅ Сохранено ${saved.length} записей в SharedPreferences');
      debugPrint(
        '📚 Сохраненные ID: ${saved.map((j) => Book.fromJson(jsonDecode(j)).id).toList()}',
      );
    } catch (e) {
      debugPrint('❌ Ошибка сохранения: $e');
    }
  }

  static Future<List<Book>> loadShelf() async {
    debugPrint('💾 StorageService.loadShelf() - НАЧАЛО');
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getStringList(_shelfKey) ?? [];
      debugPrint('📚 Найдено ${booksJson.length} записей в SharedPreferences');

      final books = booksJson
          .map((json) => Book.fromJson(jsonDecode(json)))
          .toList();

      debugPrint('✅ Загружено ${books.length} книг');
      debugPrint('📚 ID: ${books.map((b) => b.id).toList()}');
      return books;
    } catch (e) {
      debugPrint('❌ Ошибка загрузки: $e');
      return [];
    }
  }

  static Future<void> saveProgress(String bookId, int page) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progress = prefs.getString(_progressKey) ?? '{}';
      final Map<String, dynamic> progressMap = json.decode(progress);

      progressMap[bookId] = page;
      await prefs.setString(_progressKey, json.encode(progressMap));
    } catch (e) {}
  }

  static Future<int> loadProgress(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progress = prefs.getString(_progressKey) ?? '{}';
      final Map<String, dynamic> progressMap = json.decode(progress);

      final page = progressMap[bookId] as int? ?? 0;

      return page;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {}
  }
}
