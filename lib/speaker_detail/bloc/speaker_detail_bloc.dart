import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

part 'speaker_detail_event.dart';
part 'speaker_detail_state.dart';

class SpeakerDetailBloc extends Bloc<SpeakerDetailEvent, SpeakerDetailState> {
  SpeakerDetailBloc({
    required FlutterconApi api,
    required String userId,
  })  : _api = api,
        _userId = userId,
        super(const SpeakerDetailInitial()) {
    on<SpeakerDetailRequested>(_onSpeakerDetailRequested);
    on<FavoriteToggleRequested>(_onFavoriteToggleRequested);
  }

  final FlutterconApi _api;
  final String _userId;

  FutureOr<void> _onSpeakerDetailRequested(
    SpeakerDetailRequested event,
    Emitter<SpeakerDetailState> emit,
  ) async {
    emit(const SpeakerDetailLoading());
    try {
      final speaker = await _api.getSpeaker(id: event.id, userId: _userId);
      emit(
        SpeakerDetailLoaded(
          speaker: speaker,
          favoriteIds: speaker.talks
              .where((talk) => talk.isFavorite)
              .map((talk) => talk.id)
              .toList(),
        ),
      );
    } catch (error) {
      emit(SpeakerDetailError(error: error));
    }
  }

  FutureOr<void> _onFavoriteToggleRequested(
    FavoriteToggleRequested event,
    Emitter<SpeakerDetailState> emit,
  ) async {
    try {
      if (event.isFavorite) {
        await _api.removeFavorite(
          request: DeleteFavoriteRequest(
            userId: event.userId,
            talkId: event.talkId,
          ),
        );
        emit(
          (state as SpeakerDetailLoaded).copyWith(
            favoriteIds: (state as SpeakerDetailLoaded)
                .favoriteIds
                .where((id) => id != event.talkId)
                .toList(),
          ),
        );
      } else {
        await _api.addFavorite(
          request: CreateFavoriteRequest(
            userId: event.userId,
            talkId: event.talkId,
          ),
        );
        emit(
          (state as SpeakerDetailLoaded).copyWith(
            favoriteIds: [
              ...(state as SpeakerDetailLoaded).favoriteIds,
              event.talkId,
            ],
          ),
        );
      }
    } catch (e) {
      emit(SpeakerDetailError(error: e));
    }
  }
}
