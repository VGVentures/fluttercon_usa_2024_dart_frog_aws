import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:meta/meta.dart';

part 'talks_event.dart';
part 'talks_state.dart';

class TalksBloc extends Bloc<TalksEvent, TalksState> {
  TalksBloc({required FlutterconApi api})
      : _api = api,
        super(const TalksInitial()) {
    on<TalksRequested>(_onTalksRequested);
  }

  final FlutterconApi _api;

  FutureOr<void> _onTalksRequested(
    TalksRequested event,
    Emitter<TalksState> emit,
  ) async {
    try {
      emit(const TalksLoading());
      final talks = await _api.getTalks();
      emit(TalksLoaded(talkTimeSlots: talks.items));
    } catch (e) {
      emit(TalksError(error: e));
    }
  }
}
