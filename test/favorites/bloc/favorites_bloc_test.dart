import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/favorites/favorites.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  late FlutterconApi api;
  late FavoritesBloc favoritesBloc;

  setUp(() {
    api = _MockFlutterconApi();
    favoritesBloc = FavoritesBloc(api: api, userId: TestData.user.id);
  });

  group('FavoritesBloc', () {
    test('initial state is FavoritesInitial', () {
      expect(favoritesBloc.state, equals(const FavoritesInitial()));
    });

    group('FavoritesRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when successful',
        setUp: () {
          when(() => api.getFavorites(userId: TestData.user.id)).thenAnswer(
            (_) async => TestData.talkTimeSlotData(favorites: true),
          );
        },
        build: () => favoritesBloc,
        act: (bloc) {
          bloc.add(const FavoritesRequested());
        },
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesLoaded>().having(
            (state) => state.talks,
            'Talks',
            equals(TestData.talkTimeSlotData(favorites: true).items),
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when unsuccessful',
        setUp: () {
          when(() => api.getFavorites(userId: TestData.user.id)).thenThrow(
            TestData.error,
          );
        },
        build: () => favoritesBloc,
        act: (bloc) {
          bloc.add(const FavoritesRequested());
        },
        expect: () => [
          isA<FavoritesLoading>(),
          isA<FavoritesError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });

    group('RemoveFavoriteRequested', () {
      final deleteFavoriteRequest = DeleteFavoriteRequest(
        userId: TestData.user.id,
        talkId: '1',
      );

      final deleteFavoriteResponse = DeleteFavoriteResponse(
        userId: TestData.user.id,
        talkId: '1',
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'calls removeFavorite',
        setUp: () {
          when(() => api.removeFavorite(request: deleteFavoriteRequest))
              .thenAnswer((_) async => deleteFavoriteResponse);
        },
        build: () => favoritesBloc,
        seed: () => FavoritesLoaded(
          talks: TestData.talkTimeSlotData(favorites: true).items,
          favoriteIds: const ['1', '2', '3'],
        ),
        act: (bloc) {
          bloc.add(
            RemoveFavoriteRequested(
              userId: TestData.user.id,
              talkId: '1',
            ),
          );
        },
        verify: (_) => verify(
          () => api.removeFavorite(
            request: DeleteFavoriteRequest(
              userId: TestData.user.id,
              talkId: '1',
            ),
          ),
        ).called(1),
        expect: () => [
          isA<FavoritesLoaded>().having(
            (state) => state.favoriteIds,
            'FavoriteIds',
            equals(['2', '3']),
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesError] when unsuccessful',
        setUp: () {
          when(
            () => api.removeFavorite(request: deleteFavoriteRequest),
          ).thenThrow(TestData.error);
        },
        build: () => favoritesBloc,
        seed: () => FavoritesLoaded(
          talks: TestData.talkTimeSlotData(favorites: true).items,
          favoriteIds: const ['1', '2', '3'],
        ),
        act: (bloc) {
          bloc.add(
            RemoveFavoriteRequested(
              userId: TestData.user.id,
              talkId: '1',
            ),
          );
        },
        expect: () => [
          isA<FavoritesError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });
  });
}
