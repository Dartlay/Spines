part of 'reader_bloc.dart';

enum ReaderStatus { initial, loading, loaded, error }

class ReaderState extends Equatable {
  final ReaderStatus status;
  final Book? book;
  final List<String> pages;
  final int currentPage;
  final double fontSize;
  final bool showControls;
  final String? errorMessage;

  const ReaderState({
    this.status = ReaderStatus.initial,
    this.book,
    this.pages = const [],
    this.currentPage = 0,
    this.fontSize = 16,
    this.showControls = true,
    this.errorMessage,
  });

  ReaderState copyWith({
    ReaderStatus? status,
    Book? book,
    List<String>? pages,
    int? currentPage,
    double? fontSize,
    bool? showControls,
    String? errorMessage,
  }) {
    return ReaderState(
      status: status ?? this.status,
      book: book ?? this.book,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      fontSize: fontSize ?? this.fontSize,
      showControls: showControls ?? this.showControls,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get progress => pages.isEmpty ? 0 : currentPage / pages.length;

  @override
  List<Object?> get props => [
    status,
    book,
    pages,
    currentPage,
    fontSize,
    showControls,
    errorMessage,
  ];
}
