import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('TalksBloc', () {
    late FlutterconApi api;
    late TalksBloc talksBloc;

    setUp(() {
      api = _MockFlutterconApi();
      talksBloc = TalksBloc(api: api, userId: TestData.user.id);
    });

    test('initial state is TalksInitial', () {
      expect(talksBloc.state, equals(const TalksInitial()));
    });

    group('TalksRequested', () {
      blocTest<TalksBloc, TalksState>(
        'emits [TalksLoading, TalksLoaded] when successful',
        setUp: () {
          when(
            () => api.getTalks(
              userId: TestData.user.id,
            ),
          ).thenAnswer(
            (_) async => TestData.talkTimeSlotData(),
          );
        },
        build: () => talksBloc,
        act: (bloc) {
          bloc.add(const TalksRequested());
        },
        expect: () => [
          isA<TalksLoading>(),
          isA<TalksLoaded>().having(
            (state) => state.talkTimeSlots,
            'TalkTimeSlots',
            equals(TestData.talkTimeSlotData().items),
          ),
        ],
      );

      blocTest<TalksBloc, TalksState>(
        'emits [TalksLoading, TalksError] when unsuccessful',
        setUp: () {
          when(
            () => api.getTalks(
              userId: TestData.user.id,
            ),
          ).thenThrow(TestData.error);
        },
        build: () => talksBloc,
        act: (bloc) {
          bloc.add(const TalksRequested());
        },
        expect: () => [
          isA<TalksLoading>(),
          isA<TalksError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });

    group('FavoriteToggleRequested', () {
      final createFavoriteRequest = CreateFavoriteRequest(
        userId: TestData.user.id,
        talkId: '1',
      );

      final createFavoriteResponse = CreateFavoriteResponse(
        userId: TestData.user.id,
        talkId: '1',
      );

      final deleteFavoriteRequest = DeleteFavoriteRequest(
        userId: TestData.user.id,
        talkId: '1',
      );

      final deleteFavoriteResponse = DeleteFavoriteResponse(
        userId: TestData.user.id,
        talkId: '1',
      );

      blocTest<TalksBloc, TalksState>(
        'calls add favorite when talk is not currently favorite',
        setUp: () {
          when(
            () => api.addFavorite(request: createFavoriteRequest),
          ).thenAnswer(
            (_) async => createFavoriteResponse,
          );
        },
        build: () => talksBloc,
        seed: () => TalksLoaded(
          talkTimeSlots: TestData.talkTimeSlotData().items,
        ),
        act: (bloc) {
          bloc.add(
            FavoriteToggleRequested(
              userId: TestData.user.id,
              talkId: '1',
              isFavorite: false,
            ),
          );
        },
        verify: (_) => verify(
          () => api.addFavorite(
            request: CreateFavoriteRequest(
              userId: TestData.user.id,
              talkId: '1',
            ),
          ),
        ).called(1),
        expect: () => [
          isA<TalksLoaded>().having(
            (state) => state.favoriteIds,
            'FavoriteIds',
            equals(['1']),
          ),
        ],
      );

      blocTest<TalksBloc, TalksState>(
        'calls remove favorite when talk is currently favorite',
        setUp: () {
          when(
            () => api.removeFavorite(request: deleteFavoriteRequest),
          ).thenAnswer(
            (_) async => deleteFavoriteResponse,
          );
        },
        build: () => talksBloc,
        seed: () => TalksLoaded(
          talkTimeSlots: TestData.talkTimeSlotData(favorites: true).items,
          favoriteIds: const ['1', '2', '3'],
        ),
        act: (bloc) {
          bloc.add(
            FavoriteToggleRequested(
              userId: TestData.user.id,
              talkId: '1',
              isFavorite: true,
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
          isA<TalksLoaded>().having(
            (state) => state.favoriteIds,
            'FavoriteIds',
            equals(['2', '3']),
          ),
        ],
      );

      blocTest<TalksBloc, TalksState>(
        'emits [TalksError] when unsuccessful',
        setUp: () {
          when(
            () => api.removeFavorite(request: deleteFavoriteRequest),
          ).thenThrow(TestData.error);
        },
        build: () => talksBloc,
        seed: () => TalksLoaded(
          talkTimeSlots: TestData.talkTimeSlotData(favorites: true).items,
          favoriteIds: const ['1', '2', '3'],
        ),
        act: (bloc) {
          bloc.add(
            FavoriteToggleRequested(
              userId: TestData.user.id,
              talkId: '1',
              isFavorite: true,
            ),
          );
        },
        expect: () => [
          isA<TalksError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });
  });
}
