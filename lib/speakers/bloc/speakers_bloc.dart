import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

part 'speakers_event.dart';
part 'speakers_state.dart';

class SpeakersBloc extends Bloc<SpeakersEvent, SpeakersState> {
  SpeakersBloc({required FlutterconApi api})
      : _api = api,
        super(const SpeakersInitial()) {
    on<SpeakersRequested>(_speakersRequested);
  }

  final FlutterconApi _api;

  FutureOr<void> _speakersRequested(
    SpeakersRequested event,
    Emitter<SpeakersState> emit,
  ) async {
    try {
      emit(const SpeakersLoading());
      final speakers = await _api.getSpeakers();
      emit(SpeakersLoaded(speakers: speakers.items));
    } catch (e) {
      emit(SpeakersError(error: e));
    }
  }
}
