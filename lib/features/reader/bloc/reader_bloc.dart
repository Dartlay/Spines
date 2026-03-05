import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spines/core/services/epub_service.dart';
import 'package:spines/core/services/temp_storage.dart';
import 'package:spines/data/models/book.dart';
import '../../../domain/repositories/book_repository.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final BookRepository _repository;

  ReaderBloc({required BookRepository repository})
    : _repository = repository,
      super(const ReaderState()) {
    on<LoadReader>(_onLoadReader);
    on<UpdateReaderProgress>(_onUpdateReaderProgress);
    on<ChangeFontSize>(_onChangeFontSize);
    on<ToggleControls>(_onToggleControls);
  }

  Future<void> _onLoadReader(
    LoadReader event,
    Emitter<ReaderState> emit,
  ) async {
    debugPrint('🎯 ReaderBloc: загрузка книги с ID: ${event.bookId}');
    emit(state.copyWith(status: ReaderStatus.loading));

    try {
      debugPrint('📚 Вызов _repository.getBookById(${event.bookId})');
      final bookResult = await _repository.getBookById(event.bookId);

      await bookResult.fold(
        (error) async {
          debugPrint('❌ Ошибка получения книги: $error');
          emit(state.copyWith(status: ReaderStatus.error, errorMessage: error));
        },
        (book) async {
          debugPrint('✅ Книга получена: ${book.title}');
          debugPrint('📁 filePath: ${book.filePath}');

          final pages = await _loadBookContent(book);
          debugPrint('📖 Загружено ${pages.length} страниц');

          emit(
            state.copyWith(
              status: ReaderStatus.loaded,
              book: book,
              pages: pages,
              currentPage: book.currentPage,
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Ошибка: $e');
      emit(
        state.copyWith(status: ReaderStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<List<String>> _loadBookContent(Book book) async {
    try {
      debugPrint('📖 Загрузка книги: ${book.title} (ID: ${book.id})');
      debugPrint('📁 filePath из книги: ${book.filePath}');

      if (book.filePath != null && book.filePath!.startsWith('assets/')) {
        debugPrint('📖 Загрузка из assets: ${book.filePath}');
        try {
          final String content = await rootBundle.loadString(book.filePath!);
          debugPrint('✅ Загружено ${content.length} символов из assets');

          final charsPerPage = 2000;
          final pages = <String>[];
          for (int i = 0; i < content.length; i += charsPerPage) {
            final end = (i + charsPerPage < content.length)
                ? i + charsPerPage
                : content.length;
            pages.add(content.substring(i, end));
          }
          debugPrint('📖 Создано ${pages.length} страниц');
          return pages;
        } catch (e) {
          debugPrint('❌ Ошибка загрузки из assets: $e');
          return _generateFallbackContent(book);
        }
      }

      String? filePath = book.filePath;
      debugPrint('📖 Путь из книги: $filePath');

      if (filePath == null || filePath.isEmpty) {
        debugPrint('📖 Ищем в TempStorage по ID ${book.id}...');
        filePath = await TempStorage.getBookPath(book.id);
        debugPrint('📖 Путь из TempStorage: $filePath');
      }

      if (filePath == null || filePath.isEmpty) {
        debugPrint('📖 Ищем файл в директории приложения...');
        final appDir = await getApplicationDocumentsDirectory();
        final booksDir = Directory('${appDir.path}/books');

        if (await booksDir.exists()) {
          final files = await booksDir.list().toList();
          debugPrint('📁 Найдено файлов: ${files.length}');

          for (final file in files) {
            final fileName = file.path.split('/').last;
            debugPrint('📖 Проверяем: $fileName');

            if (fileName.contains(book.id)) {
              filePath = file.path;
              debugPrint('✅ Найден файл по частичному совпадению: $filePath');
              break;
            }
          }
        }
      }

      if (filePath == null || filePath.isEmpty) {
        debugPrint('❌ Файл для книги ${book.id} не найден!');

        final allPaths = await TempStorage.getAllBookPaths();
        debugPrint('📚 Все пути в TempStorage: $allPaths');

        return _generateFallbackContent(book);
      }

      debugPrint('📖 Загрузка книги из файла: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('❌ Файл не существует: $filePath');
        return _generateFallbackContent(book);
      }

      final extension = filePath.split('.').last.toLowerCase();
      debugPrint('📖 Расширение файла: $extension');

      if (extension == 'epub') {
        debugPrint('📖 Чтение EPUB файла...');
        final chapters = await EpubService.extractText(filePath);

        if (chapters.isNotEmpty) {
          final allText = chapters.join('\n\n');
          debugPrint('📖 Извлечено ${allText.length} символов');

          final charsPerPage = 2000;
          final pages = <String>[];

          for (int i = 0; i < allText.length; i += charsPerPage) {
            final end = (i + charsPerPage < allText.length)
                ? i + charsPerPage
                : allText.length;
            pages.add(allText.substring(i, end));
          }

          debugPrint('📖 Создано ${pages.length} страниц');
          return pages;
        }
      }

      if (extension == 'txt') {
        debugPrint('📖 Чтение TXT файла...');
        final content = await file.readAsString();
        debugPrint('📖 Загружено ${content.length} символов');

        final charsPerPage = 2000;
        final pages = <String>[];

        for (int i = 0; i < content.length; i += charsPerPage) {
          final end = (i + charsPerPage < content.length)
              ? i + charsPerPage
              : content.length;
          pages.add(content.substring(i, end));
        }

        debugPrint('📖 Создано ${pages.length} страниц');
        return pages;
      }

      debugPrint('⚠️ Неподдерживаемый формат: $extension');
      return _generateFallbackContent(book);
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      return _generateFallbackContent(book);
    }
  }

  Future<List<String>> _readFile(File file, Book book) async {
    final extension = book.filePath!.split('.').last.toLowerCase();

    if (extension == 'epub') {
      debugPrint('📖 Чтение EPUB файла...');
      final chapters = await EpubService.extractText(book.filePath!);
      if (chapters.isNotEmpty) {
        final allText = chapters.join('\n\n');
        debugPrint('📖 Извлечено ${allText.length} символов');

        final charsPerPage = 2000;
        final pages = <String>[];
        for (int i = 0; i < allText.length; i += charsPerPage) {
          final end = (i + charsPerPage < allText.length)
              ? i + charsPerPage
              : allText.length;
          pages.add(allText.substring(i, end));
        }
        debugPrint('📖 Создано ${pages.length} страниц');
        return pages;
      }
    }

    if (extension == 'txt') {
      debugPrint('📖 Чтение TXT файла...');
      final content = await file.readAsString();
      debugPrint('📖 Загружено ${content.length} символов');

      final charsPerPage = 2000;
      final pages = <String>[];
      for (int i = 0; i < content.length; i += charsPerPage) {
        final end = (i + charsPerPage < content.length)
            ? i + charsPerPage
            : content.length;
        pages.add(content.substring(i, end));
      }
      return pages;
    }

    return _generateFallbackContent(book);
  }

  List<String> _splitIntoPages(String content, int totalPages) {
    if (content.isEmpty) {
      return List.generate(
        totalPages,
        (i) => 'Страница ${i + 1}\n\n[Пустая страница]',
      );
    }

    final int pageSize = (content.length / totalPages).ceil();
    final List<String> pages = [];

    for (int i = 0; i < totalPages; i++) {
      final start = i * pageSize;
      if (start >= content.length) break;

      final end = (start + pageSize) < content.length
          ? start + pageSize
          : content.length;

      pages.add(content.substring(start, end));
    }

    return pages;
  }

  List<String> _generateFallbackContent(Book book) {
    return List.generate(
      book.pages,
      (i) =>
          '''
Страница ${i + 1} из ${book.pages}

${book.title}
${book.author}

[Файл книги не найден: ${book.filePath ?? 'не указан'}]

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

-- Продолжение следует --
''',
    );
  }

  Future<void> _onUpdateReaderProgress(
    UpdateReaderProgress event,
    Emitter<ReaderState> emit,
  ) async {
    await _repository.updateProgress(event.bookId, event.page);
    emit(state.copyWith(currentPage: event.page));
  }

  void _onChangeFontSize(ChangeFontSize event, Emitter<ReaderState> emit) {
    emit(state.copyWith(fontSize: event.fontSize));
  }

  void _onToggleControls(ToggleControls event, Emitter<ReaderState> emit) {
    emit(state.copyWith(showControls: !state.showControls));
  }
}
