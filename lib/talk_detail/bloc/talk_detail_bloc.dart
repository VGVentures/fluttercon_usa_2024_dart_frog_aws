import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

part 'talk_detail_event.dart';
part 'talk_detail_state.dart';

class TalkDetailBloc extends Bloc<TalkDetailEvent, TalkDetailState> {
  TalkDetailBloc({
    required FlutterconApi api,
  })  : _api = api,
        super(const TalkDetailInitial()) {
    on<TalkDetailRequested>(_onTalkDetailRequested);
  }

  final FlutterconApi _api;

  FutureOr<void> _onTalkDetailRequested(
    TalkDetailRequested event,
    Emitter<TalkDetailState> emit,
  ) async {
    try {
      emit(const TalkDetailLoading());
      final talk = await _api.getTalk(id: event.id);
      emit(
        TalkDetailLoaded(talk: talk),
      );
    } catch (e) {
      emit(TalkDetailError(error: e));
    }
  }
}
