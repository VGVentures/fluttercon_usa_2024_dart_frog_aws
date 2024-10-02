part of 'speaker_detail_bloc.dart';

sealed class SpeakerDetailState extends Equatable {
  const SpeakerDetailState();
}

final class SpeakerDetailInitial extends SpeakerDetailState {
  const SpeakerDetailInitial();

  @override
  List<Object> get props => [];
}

final class SpeakerDetailLoading extends SpeakerDetailState {
  const SpeakerDetailLoading();

  @override
  List<Object> get props => [];
}

final class SpeakerDetailLoaded extends SpeakerDetailState {
  const SpeakerDetailLoaded({
    required this.speaker,
    this.favoriteIds = const [],
  });

  final SpeakerDetail speaker;
  final List<String> favoriteIds;

  @override
  List<Object?> get props => [
        speaker,
        favoriteIds,
      ];

  SpeakerDetailLoaded copyWith({
    SpeakerDetail? speaker,
    List<String>? favoriteIds,
  }) {
    return SpeakerDetailLoaded(
      speaker: speaker ?? this.speaker,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

final class SpeakerDetailError extends SpeakerDetailState {
  const SpeakerDetailError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}
