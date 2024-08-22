part of 'talks_bloc.dart';

@immutable
sealed class TalksState {
  const TalksState();
}

final class TalksInitial extends TalksState {}

final class TalksLoading extends TalksState {}

final class TalksLoaded extends TalksState {
  const TalksLoaded({required this.talkTimeSlots});

  final List<TalkTimeSlot> talkTimeSlots;
}

final class TalksError extends TalksState {
  const TalksError({required this.error});

  final Object error;
}
