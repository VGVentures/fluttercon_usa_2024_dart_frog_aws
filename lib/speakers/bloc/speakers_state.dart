part of 'speakers_bloc.dart';

sealed class SpeakersState extends Equatable {
  const SpeakersState();
}

final class SpeakersInitial extends SpeakersState {
  const SpeakersInitial();

  @override
  List<Object> get props => [];
}

final class SpeakersLoading extends SpeakersState {
  const SpeakersLoading();

  @override
  List<Object> get props => [];
}

final class SpeakersLoaded extends SpeakersState {
  const SpeakersLoaded({required this.speakers});

  final List<SpeakerPreview> speakers;

  @override
  List<Object> get props => [speakers];
}

final class SpeakersError extends SpeakersState {
  const SpeakersError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}
