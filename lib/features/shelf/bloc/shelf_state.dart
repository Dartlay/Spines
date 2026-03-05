part of 'shelf_bloc.dart';

enum ShelfStatus { initial, loading, loaded, error, filePicking }

class ShelfState extends Equatable {
  final ShelfStatus status;
  final List<Book> books;
  final String? errorMessage;
  final bool isPickingFile;

  const ShelfState({
    this.status = ShelfStatus.initial,
    this.books = const [],
    this.errorMessage,
    this.isPickingFile = false,
  });

  ShelfState copyWith({
    ShelfStatus? status,
    List<Book>? books,
    String? errorMessage,
    bool? isPickingFile,
  }) {
    return ShelfState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage ?? this.errorMessage,
      isPickingFile: isPickingFile ?? this.isPickingFile,
    );
  }

  @override
  List<Object?> get props => [status, books, errorMessage, isPickingFile];
}
