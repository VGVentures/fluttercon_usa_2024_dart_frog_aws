part of 'talks_bloc.dart';

@immutable
sealed class TalksEvent {
  const TalksEvent();
}

final class TalksRequested extends TalksEvent {
  const TalksRequested();
}
