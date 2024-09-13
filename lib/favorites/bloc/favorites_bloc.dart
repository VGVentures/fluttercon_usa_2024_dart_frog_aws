import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required FlutterconApi api,
    required String userId,
  })  : _api = api,
        _userId = userId,
        super(const FavoritesInitial()) {
    on<FavoritesRequested>(_favoritesRequested);
    on<RemoveFavoriteRequested>(_removeFavoriteRequested);
  }

  final FlutterconApi _api;
  final String _userId;

  FutureOr<void> _favoritesRequested(
    FavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(const FavoritesLoading());
      final talks = await _api.getFavorites(userId: _userId);
      emit(
        FavoritesLoaded(
          talks: talks.items,
          favoriteIds: talks.items
              .map((e) => e.talks.where((t) => t.isFavorite).map((t) => t.id))
              .expand((e) => e)
              .toList(),
        ),
      );
    } catch (e) {
      emit(FavoritesError(error: e));
    }
  }

  FutureOr<void> _removeFavoriteRequested(
    RemoveFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await _api.removeFavorite(
        request: DeleteFavoriteRequest(
          userId: _userId,
          talkId: event.talkId,
        ),
      );
      emit(
        (state as FavoritesLoaded).copyWith(
          favoriteIds: (state as FavoritesLoaded)
              .favoriteIds
              .where((id) => id != event.talkId)
              .toList(),
        ),
      );
      print('New favorite ids: ${(state as FavoritesLoaded).favoriteIds}');
    } catch (e) {
      emit(FavoritesError(error: e));
    }
  }
}
