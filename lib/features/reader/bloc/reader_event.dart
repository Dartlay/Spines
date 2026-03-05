part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();
}

class LoadReader extends ReaderEvent {
  final String bookId;

  const LoadReader(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class UpdateReaderProgress extends ReaderEvent {
  final String bookId;
  final int page;

  const UpdateReaderProgress(this.bookId, this.page);

  @override
  List<Object?> get props => [bookId, page];
}

class ChangeFontSize extends ReaderEvent {
  final double fontSize;

  const ChangeFontSize(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}

class ToggleControls extends ReaderEvent {
  const ToggleControls();

  @override
  List<Object?> get props => [];
}
