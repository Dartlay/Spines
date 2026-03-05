import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spines/core/services/epub_service.dart';
import 'package:spines/core/services/temp_storage.dart';
import 'package:spines/data/models/book.dart';
import '../../../domain/repositories/book_repository.dart';

part 'shelf_event.dart';
part 'shelf_state.dart';

class ShelfBloc extends Bloc<ShelfEvent, ShelfState> {
  final BookRepository _repository;

  ShelfBloc({required BookRepository repository})
    : _repository = repository,
      super(const ShelfState()) {
    on<LoadShelf>(_onLoadShelf);
    on<PickAndAddBook>(_onPickAndAddBook);
    on<AddBookWithFile>(_onAddBookWithFile);
    on<AddToShelf>(_onAddToShelf);
    on<UpdateBookInfo>(_onUpdateBookInfo);
    on<RemoveFromShelf>(_onRemoveFromShelf);
    on<UpdateShelfProgress>(_onUpdateShelfProgress);
    on<RefreshShelf>(_onRefreshShelf);
  }

  Future<void> _onLoadShelf(LoadShelf event, Emitter<ShelfState> emit) async {
    debugPrint('🎯 ShelfBloc: загрузка полки - НАЧАЛО');
    emit(state.copyWith(status: ShelfStatus.loading, errorMessage: null));

    try {
      final result = await _repository.getShelfBooks();

      result.fold(
        (error) {
          debugPrint('❌ Ошибка загрузки: $error');
          emit(state.copyWith(status: ShelfStatus.error, errorMessage: error));
        },
        (books) {
          debugPrint('✅ Загружено ${books.length} книг');
          debugPrint(
            '📚 ID загруженных книг: ${books.map((b) => b.id).toList()}',
          );
          emit(
            state.copyWith(status: ShelfStatus.loaded, books: List.from(books)),
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Ошибка: $e');
      emit(
        state.copyWith(status: ShelfStatus.error, errorMessage: e.toString()),
      );
    }
    debugPrint('🎯 ShelfBloc: загрузка полки - КОНЕЦ');
  }

  Future<void> _onPickAndAddBook(
    PickAndAddBook event,
    Emitter<ShelfState> emit,
  ) async {
    debugPrint('🎯 ShelfBloc: выбор файла - НАЧАЛО');
    emit(state.copyWith(isPickingFile: true, errorMessage: null));

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'epub', 'fb2'],
      );

      if (result != null) {
        final filePath = result.files.single.path;
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        debugPrint('📁 Файл выбран: $fileName');
        debugPrint('📁 Размер: $fileSize байт');
        debugPrint('📁 Путь: $filePath');

        if (filePath != null) {
          debugPrint('✅ Путь получен, добавляем событие AddBookWithFile');
          add(AddBookWithFile(filePath: filePath, fileName: fileName));
        } else {
          debugPrint('❌ Путь к файлу = null');
          emit(
            state.copyWith(
              status: ShelfStatus.error,
              errorMessage: 'Не удалось получить путь к файлу',
              isPickingFile: false,
            ),
          );
        }
      } else {
        debugPrint('📁 Файл не выбран (пользователь отменил)');
        emit(state.copyWith(isPickingFile: false));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка выбора файла: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      emit(
        state.copyWith(
          status: ShelfStatus.error,
          errorMessage: 'Ошибка выбора файла: $e',
          isPickingFile: false,
        ),
      );
    }
    debugPrint('🎯 ShelfBloc: выбор файла - КОНЕЦ');
  }

  Future<void> _onAddBookWithFile(
    AddBookWithFile event,
    Emitter<ShelfState> emit,
  ) async {
    debugPrint('🎯 ShelfBloc: добавление книги с файлом - НАЧАЛО');
    debugPrint('📁 event.filePath: ${event.filePath}');
    debugPrint('📁 event.fileName: ${event.fileName}');

    emit(state.copyWith(status: ShelfStatus.loading));

    try {
      final file = File(event.filePath);
      final exists = await file.exists();
      debugPrint('📁 Файл существует: $exists');

      if (!exists) {
        throw Exception('Файл не существует по пути: ${event.filePath}');
      }

      final appDir = await getApplicationDocumentsDirectory();
      debugPrint('📁 appDir: ${appDir.path}');

      final booksDir = Directory('${appDir.path}/books');
      debugPrint('📁 booksDir: ${booksDir.path}');

      if (!await booksDir.exists()) {
        debugPrint('📁 Создаем папку books');
        await booksDir.create(recursive: true);
      }
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = event.fileName.split('.').last;
      final safeFileName = 'book_$timestamp.$fileExtension';
      debugPrint('📁 safeFileName: $safeFileName');

      final newFile = File('${booksDir.path}/$safeFileName');
      await file.copy(newFile.path);
      debugPrint('✅ Файл скопирован: ${newFile.path}');
      final extension = event.fileName.split('.').last.toLowerCase();
      debugPrint('📁 extension: $extension');

      String title = event.fileName.split('.').first;
      String author = 'Неизвестный автор';
      int pages = 100;

      if (extension == 'epub') {
        debugPrint('📚 Определили EPUB, получаем метаданные');
        final metadata = await EpubService.getMetadata(newFile.path);
        title = metadata['title'] ?? title;
        author = metadata['author'] ?? author;
        pages = metadata['pages'] ?? 100;
        debugPrint(
          '📚 Метаданные: title="$title", author="$author", pages=$pages',
        );
      }

      final bookId = DateTime.now().millisecondsSinceEpoch.toString();
      debugPrint('📚 bookId: $bookId');

      await TempStorage.saveBookPath(bookId, newFile.path);
      debugPrint('💾 Путь сохранен в TempStorage');

      final newBook = Book(
        id: bookId,
        title: title,
        author: author,
        description: 'Загруженная книга',
        rating: 0.0,
        pages: pages,
        filePath: newFile.path,
        genres: [],
        publicationYear: DateTime.now().year,
        language: 'Русский',
        isNew: true,
      );
      debugPrint('📚 Объект Book создан: ${newBook.title}');

      await _repository.addToShelf(bookId);
      debugPrint('✅ Книга добавлена в репозиторий');

      final savedPath = await TempStorage.getBookPath(bookId);
      debugPrint('🔍 Проверка: путь для книги $bookId: $savedPath');

      emit(state.copyWith(status: ShelfStatus.loaded, errorMessage: null));
      debugPrint('📤 Отправляем LoadShelf');

      add(const LoadShelf());
    } catch (e, stackTrace) {
      debugPrint('❌ Ошибка добавления книги: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      emit(
        state.copyWith(
          status: ShelfStatus.error,
          errorMessage: 'Ошибка добавления книги: $e',
        ),
      );
    }
    debugPrint('🎯 ShelfBloc: добавление книги с файлом - КОНЕЦ');
  }

  Future<void> _onAddToShelf(AddToShelf event, Emitter<ShelfState> emit) async {
    try {
      await _repository.addToShelf(event.bookId);
      add(const LoadShelf());
    } catch (e) {
      emit(
        state.copyWith(
          status: ShelfStatus.error,
          errorMessage: 'Ошибка добавления книги: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateBookInfo(
    UpdateBookInfo event,
    Emitter<ShelfState> emit,
  ) async {
    emit(state.copyWith(status: ShelfStatus.loading));

    try {
      await _repository.updateBookInfo(
        bookId: event.bookId,
        title: event.title,
        author: event.author,
        publicationYear: event.publicationYear,
        description: event.description,
      );

      add(const LoadShelf());
    } catch (e) {
      emit(
        state.copyWith(
          status: ShelfStatus.error,
          errorMessage: 'Ошибка обновления книги: $e',
        ),
      );
    }
  }

  Future<void> _onRemoveFromShelf(
    RemoveFromShelf event,
    Emitter<ShelfState> emit,
  ) async {
    emit(state.copyWith(status: ShelfStatus.loading));

    try {
      await _repository.removeFromShelf(event.bookId);
      add(const LoadShelf());
    } catch (e) {
      emit(
        state.copyWith(
          status: ShelfStatus.error,
          errorMessage: 'Ошибка удаления книги: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateShelfProgress(
    UpdateShelfProgress event,
    Emitter<ShelfState> emit,
  ) async {
    try {
      await _repository.updateProgress(event.bookId, event.page);
      add(const LoadShelf());
    } catch (e) {}
  }

  Future<void> _onRefreshShelf(
    RefreshShelf event,
    Emitter<ShelfState> emit,
  ) async {
    emit(state.copyWith(status: ShelfStatus.loading));
    add(const LoadShelf());
  }
}
