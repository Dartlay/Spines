part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();

  @override
  List<Object?> get props => [];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String bookId;

  const RemoveFromFavorites(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class RefreshFavorites extends FavoritesEvent {
  const RefreshFavorites();

  @override
  List<Object?> get props => [];
}
