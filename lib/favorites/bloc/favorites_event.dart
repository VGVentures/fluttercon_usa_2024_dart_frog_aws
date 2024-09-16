part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

final class FavoritesRequested extends FavoritesEvent {
  const FavoritesRequested();

  @override
  List<Object> get props => [];
}

final class RemoveFavoriteRequested extends FavoritesEvent {
  const RemoveFavoriteRequested({
    required this.userId,
    required this.talkId,
  });

  final String userId;
  final String talkId;

  @override
  List<Object> get props => [userId, talkId];
}
