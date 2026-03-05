part of 'shelf_bloc.dart';

abstract class ShelfEvent extends Equatable {
  const ShelfEvent();

  @override
  List<Object?> get props => [];
}

class LoadShelf extends ShelfEvent {
  const LoadShelf();
}

class PickAndAddBook extends ShelfEvent {
  const PickAndAddBook();
}

class AddBookWithFile extends ShelfEvent {
  final String filePath;
  final String fileName;

  const AddBookWithFile({required this.filePath, required this.fileName});

  @override
  List<Object?> get props => [filePath, fileName];
}

class AddToShelf extends ShelfEvent {
  final String bookId;

  const AddToShelf(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class UpdateBookInfo extends ShelfEvent {
  final String bookId;
  final String title;
  final String author;
  final int? publicationYear;
  final String? description;

  const UpdateBookInfo({
    required this.bookId,
    required this.title,
    required this.author,
    this.publicationYear,
    this.description,
  });

  @override
  List<Object?> get props => [
    bookId,
    title,
    author,
    publicationYear,
    description,
  ];
}

class RemoveFromShelf extends ShelfEvent {
  final String bookId;

  const RemoveFromShelf(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class UpdateShelfProgress extends ShelfEvent {
  final String bookId;
  final int page;

  const UpdateShelfProgress(this.bookId, this.page);

  @override
  List<Object?> get props => [bookId, page];
}

class RefreshShelf extends ShelfEvent {
  const RefreshShelf();
}
