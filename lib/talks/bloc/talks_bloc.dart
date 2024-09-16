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
    on<TalkRequested>(_onTalkRequested);
    on<TalksRequested>(_onTalksRequested);
    on<FavoriteToggleRequested>(_onFavoriteToggleRequested);
  }

  final FlutterconApi _api;

  FutureOr<void> _onTalksRequested(
    TalksRequested event,
    Emitter<TalksState> emit,
  ) async {
    try {
      emit(const TalksLoading());
      final talks = await _api.getTalks();
      emit(
        TalksLoaded(
          talkTimeSlots: talks.items,
          favoriteIds: talks.items
              .map((e) => e.talks.where((t) => t.isFavorite).map((t) => t.id))
              .expand((e) => e)
              .toList(),
        ),
      );
    } catch (e) {
      emit(TalksError(error: e));
    }
  }

  FutureOr<void> _onFavoriteToggleRequested(
    FavoriteToggleRequested event,
    Emitter<TalksState> emit,
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
          (state as TalksLoaded).copyWith(
            favoriteIds: (state as TalksLoaded)
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
          (state as TalksLoaded).copyWith(
            favoriteIds: [
              ...(state as TalksLoaded).favoriteIds,
              event.talkId,
            ],
          ),
        );
      }
    } catch (e) {
      emit(TalksError(error: e));
    }
  }

  FutureOr<void> _onTalkRequested(
    TalkRequested event,
    Emitter<TalksState> emit,
  ) async {
    try {
      final talk = await _api.getTalk(id: event.id);
      emit(
        (state as TalksLoaded).copyWith(
          talkDetail: talk,
        ),
      );
    } catch (e) {
      emit(TalksError(error: e));
    }
  }
}
