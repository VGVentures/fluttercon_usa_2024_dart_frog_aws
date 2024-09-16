part of 'talks_bloc.dart';

@immutable
sealed class TalksEvent extends Equatable {
  const TalksEvent();
}

final class TalksRequested extends TalksEvent {
  const TalksRequested();

  @override
  List<Object?> get props => [];
}

final class FavoriteToggleRequested extends TalksEvent {
  const FavoriteToggleRequested({
    required this.userId,
    required this.talkId,
    required this.isFavorite,
  });

  final String userId;
  final String talkId;
  final bool isFavorite;

  @override
  List<Object?> get props => [userId, talkId, isFavorite];
}

final class TalkRequested extends TalksEvent {
  const TalkRequested({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
