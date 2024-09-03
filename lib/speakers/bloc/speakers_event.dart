part of 'speakers_bloc.dart';

sealed class SpeakersEvent extends Equatable {
  const SpeakersEvent();
}

final class SpeakersRequested extends SpeakersEvent {
  const SpeakersRequested();

  @override
  List<Object?> get props => [];
}
