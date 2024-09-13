part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();

  @override
  List<Object> get props => [];
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();

  @override
  List<Object> get props => [];
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({required this.talks, required this.favoriteIds});

  final List<TalkTimeSlot> talks;
  final List<String> favoriteIds;

  @override
  List<Object> get props => [talks, favoriteIds];

  FavoritesLoaded copyWith({
    List<TalkTimeSlot>? talks,
    List<String>? favoriteIds,
  }) {
    return FavoritesLoaded(
      talks: talks ?? this.talks,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

final class FavoritesError extends FavoritesState {
  const FavoritesError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}
