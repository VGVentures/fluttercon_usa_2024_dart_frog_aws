part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}
