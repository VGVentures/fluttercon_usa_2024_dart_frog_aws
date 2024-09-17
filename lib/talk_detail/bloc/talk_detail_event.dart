part of 'talk_detail_bloc.dart';

sealed class TalkDetailEvent extends Equatable {
  const TalkDetailEvent();
}

final class TalkDetailRequested extends TalkDetailEvent {
  const TalkDetailRequested({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
