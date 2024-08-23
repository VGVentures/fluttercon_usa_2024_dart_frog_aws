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
