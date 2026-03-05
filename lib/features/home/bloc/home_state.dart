part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Book> allBooks;
  final List<Book> recommendedBooks;
  final List<Book> popularBooks;
  final List<Book> newBooks;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.allBooks = const [],
    this.recommendedBooks = const [],
    this.popularBooks = const [],
    this.newBooks = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Book>? allBooks,
    List<Book>? recommendedBooks,
    List<Book>? popularBooks,
    List<Book>? newBooks,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      allBooks: allBooks ?? this.allBooks,
      recommendedBooks: recommendedBooks ?? this.recommendedBooks,
      popularBooks: popularBooks ?? this.popularBooks,
      newBooks: newBooks ?? this.newBooks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allBooks,
    recommendedBooks,
    popularBooks,
    newBooks,
    errorMessage,
  ];
}
