part of 'talks_bloc.dart';

@immutable
sealed class TalksState extends Equatable {
  const TalksState();
}

final class TalksInitial extends TalksState {
  const TalksInitial();

  @override
  List<Object> get props => [];
}

final class TalksLoading extends TalksState {
  const TalksLoading();

  @override
  List<Object> get props => [];
}

final class TalksLoaded extends TalksState {
  const TalksLoaded({required this.talkTimeSlots, this.favoriteIds = const []});

  final List<TalkTimeSlot> talkTimeSlots;
  final List<String> favoriteIds;

  @override
  List<Object> get props => [talkTimeSlots, favoriteIds];

  TalksLoaded copyWith({
    List<TalkTimeSlot>? talkTimeSlots,
    List<String>? favoriteIds,
  }) {
    return TalksLoaded(
      talkTimeSlots: talkTimeSlots ?? this.talkTimeSlots,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

final class TalksError extends TalksState {
  const TalksError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}
