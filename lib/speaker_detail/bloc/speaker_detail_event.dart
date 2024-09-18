part of 'speaker_detail_bloc.dart';

sealed class SpeakerDetailEvent extends Equatable {
  const SpeakerDetailEvent();

  @override
  List<Object?> get props => [];
}

final class SpeakerDetailRequested extends SpeakerDetailEvent {
  const SpeakerDetailRequested({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

final class FavoriteToggleRequested extends SpeakerDetailEvent {
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
