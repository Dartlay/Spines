part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();

  @override
  List<Object?> get props => [];
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();

  @override
  List<Object?> get props => [];
}
