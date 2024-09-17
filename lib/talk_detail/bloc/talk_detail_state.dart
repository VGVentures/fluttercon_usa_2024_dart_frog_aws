part of 'talk_detail_bloc.dart';

sealed class TalkDetailState extends Equatable {
  const TalkDetailState();
}

final class TalkDetailInitial extends TalkDetailState {
  const TalkDetailInitial();

  @override
  List<Object> get props => [];
}

final class TalkDetailLoading extends TalkDetailState {
  const TalkDetailLoading();

  @override
  List<Object> get props => [];
}

final class TalkDetailLoaded extends TalkDetailState {
  const TalkDetailLoaded({
    required this.talk,
  });

  final TalkDetail talk;

  @override
  List<Object?> get props => [
        talk,
      ];

  TalkDetailLoaded copyWith({
    TalkDetail? talk,
  }) {
    return TalkDetailLoaded(
      talk: talk ?? this.talk,
    );
  }
}

final class TalkDetailError extends TalkDetailState {
  const TalkDetailError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}
