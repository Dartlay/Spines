import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spines/data/models/book.dart';
import '../../../domain/repositories/book_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final BookRepository _repository;

  FavoritesBloc({required BookRepository repository})
    : _repository = repository,
      super(const FavoritesState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      final result = await _repository.getFavoriteBooks();

      result.fold(
        (error) {
          emit(
            state.copyWith(status: FavoritesStatus.error, errorMessage: error),
          );
        },
        (books) {
          emit(state.copyWith(status: FavoritesStatus.loaded, books: books));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _repository.toggleFavorite(event.bookId);
      add(const LoadFavorites());
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      final result = await _repository.getFavoriteBooks();

      result.fold(
        (error) {
          emit(
            state.copyWith(status: FavoritesStatus.error, errorMessage: error),
          );
        },
        (books) {
          emit(
            state.copyWith(
              status: FavoritesStatus.loaded,
              books: List.from(books),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
