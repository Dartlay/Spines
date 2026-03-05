import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempStorage {
  static const String _filePathPrefix = 'book_file_';

  static Future<void> saveBookPath(String bookId, String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('book_file_$bookId', filePath);
  }

  static Future<String?> getBookPath(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('$_filePathPrefix$bookId');

      if (path != null) {
        if (await File(path).exists()) {
          return path;
        } else {
          await prefs.remove('$_filePathPrefix$bookId');
        }
      } else {}
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, String>> getAllBookPaths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final Map<String, String> paths = {};

      for (final key in keys) {
        if (key.startsWith(_filePathPrefix)) {
          final bookId = key.substring(_filePathPrefix.length);
          final path = prefs.getString(key);
          if (path != null) {
            paths[bookId] = path;
          }
        }
      }
      debugPrint('📚 Все пути в TempStorage: $paths');
      return paths;
    } catch (e) {
      debugPrint('❌ Ошибка получения всех путей: $e');
      return {};
    }
  }

  static Future<void> removeBookPath(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_filePathPrefix$bookId');
    } catch (e) {}
  }

  static Future<void> _debugPrintAllPaths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_filePathPrefix)) {
          final value = prefs.getString(key);
        }
      }
    } catch (e) {}
  }

  static Future<void> clearAllPaths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_filePathPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {}
  }
}
