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
  const TalksLoaded({required this.talkTimeSlots});

  final List<TalkTimeSlot> talkTimeSlots;

  @override
  List<Object> get props => [talkTimeSlots];
}

final class TalksError extends TalksState {
  const TalksError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}
