import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spines/data/models/book.dart';
import '../../../domain/repositories/book_repository.dart';
import '../../filters/bloc/filter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository _repository;
  final FilterBloc _filterBloc;

  HomeBloc({required BookRepository repository, required FilterBloc filterBloc})
    : _repository = repository,
      _filterBloc = filterBloc,
      super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);

    _filterBloc.stream.listen((filterState) {
      if (filterState.isInitialized) {
        add(RefreshHomeData());
      }
    });
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final allBooksResult = await _repository.getBooks();
      final recommendedResult = await _repository.getRecommendedBooks();
      final popularResult = await _repository.getPopularBooks();
      final newResult = await _repository.getNewBooks();

      await allBooksResult.fold(
        (error) async =>
            emit(state.copyWith(status: HomeStatus.error, errorMessage: error)),
        (allBooks) async {
          List<Book> recommended = [];
          List<Book> popular = [];
          List<Book> newBooks = [];

          recommendedResult.fold(
            (error) => null,
            (books) => recommended = books,
          );

          popularResult.fold((error) => null, (books) => popular = books);

          newResult.fold((error) => null, (books) => newBooks = books);

          _filterBloc.add(InitializeFilters(allBooks));

          emit(
            state.copyWith(
              status: HomeStatus.loaded,
              allBooks: allBooks,
              recommendedBooks: recommended,
              popularBooks: popular,
              newBooks: newBooks,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    add(const LoadHomeData());
  }
}
