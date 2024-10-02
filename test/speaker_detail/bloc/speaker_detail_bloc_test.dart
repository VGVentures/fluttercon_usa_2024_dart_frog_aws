import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';
import 'package:fluttercon_usa_2024/utils/url_launcher.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

class _MockUrlLauncher extends Mock implements UrlLauncher {}

void main() {
  group('SpeakerDetailBloc', () {
    late FlutterconApi api;
    late UrlLauncher urlLauncher;
    late SpeakerDetailBloc speakerDetailBloc;
    const speakerId = 'speakerId';

    setUp(() {
      api = _MockFlutterconApi();
      urlLauncher = _MockUrlLauncher();
      speakerDetailBloc = SpeakerDetailBloc(
        api: api,
        userId: TestData.user.id,
        urlLauncher: urlLauncher,
      );
    });

    test('initial state is SpeakerDetailInitial', () {
      expect(speakerDetailBloc.state, const SpeakerDetailInitial());
    });

    group('SpeakerDetailRequested', () {
      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'emits [SpeakerDetailLoading, SpeakerDetailLoaded] '
        'when successful',
        setUp: () {
          when(() => api.getSpeaker(id: speakerId, userId: TestData.user.id))
              .thenAnswer(
            (_) async => TestData.speakerDetail,
          );
        },
        build: () => speakerDetailBloc,
        act: (bloc) {
          bloc.add(const SpeakerDetailRequested(id: speakerId));
        },
        expect: () => [
          isA<SpeakerDetailLoading>(),
          isA<SpeakerDetailLoaded>().having(
            (state) => state.speaker,
            'Speaker',
            equals(TestData.speakerDetail),
          ),
        ],
      );

      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'emits [SpeakerDetailLoading, SpeakerDetailError] '
        'when unsuccessful',
        setUp: () {
          when(
            () => api.getSpeaker(
              id: speakerId,
              userId: TestData.user.id,
            ),
          ).thenThrow(TestData.error);
        },
        build: () => speakerDetailBloc,
        act: (bloc) {
          bloc.add(const SpeakerDetailRequested(id: speakerId));
        },
        expect: () => [
          isA<SpeakerDetailLoading>(),
          isA<SpeakerDetailError>().having(
            (state) => state.error,
            'error',
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

      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'calls add favorite when talk is not currently favorite',
        setUp: () {
          when(
            () => api.addFavorite(request: createFavoriteRequest),
          ).thenAnswer(
            (_) async => createFavoriteResponse,
          );
        },
        build: () => speakerDetailBloc,
        seed: () => SpeakerDetailLoaded(
          speaker: TestData.speakerDetail,
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
          isA<SpeakerDetailLoaded>().having(
            (state) => state.favoriteIds,
            'FavoriteIds',
            equals(['1']),
          ),
        ],
      );

      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'calls remove favorite when talk is currently favorite',
        setUp: () {
          when(
            () => api.removeFavorite(request: deleteFavoriteRequest),
          ).thenAnswer(
            (_) async => deleteFavoriteResponse,
          );
        },
        build: () => speakerDetailBloc,
        seed: () => SpeakerDetailLoaded(
          speaker: TestData.speakerDetail,
          favoriteIds: const ['1'],
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
          isA<SpeakerDetailLoaded>().having(
            (state) => state.favoriteIds,
            'FavoriteIds',
            isEmpty,
          ),
        ],
      );

      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'emits [SpeakerDetailError] when unsuccessful',
        setUp: () {
          when(
            () => api.removeFavorite(request: deleteFavoriteRequest),
          ).thenThrow(TestData.error);
        },
        build: () => speakerDetailBloc,
        seed: () => SpeakerDetailLoaded(
          speaker: TestData.speakerDetail,
          favoriteIds: const ['1'],
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
          isA<SpeakerDetailError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });

    group('SpeakerLinkTapped', () {
      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'launches url when url is valid',
        setUp: () {
          when(() => urlLauncher.validateUrl(url: any(named: 'url')))
              .thenAnswer((_) async => true);
          when(() => urlLauncher.launchUrl(url: any(named: 'url')))
              .thenAnswer((_) async {});
        },
        build: () => speakerDetailBloc,
        act: (bloc) =>
            bloc.add(const SpeakerLinkTapped(url: 'https://url.com')),
        verify: (_) {
          verify(() => urlLauncher.launchUrl(url: any(named: 'url'))).called(1);
        },
      );

      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'does not launch url when url is invalid',
        setUp: () {
          when(() => urlLauncher.validateUrl(url: any(named: 'url')))
              .thenAnswer((_) async => false);
          when(() => urlLauncher.launchUrl(url: any(named: 'url')))
              .thenAnswer((_) async {});
        },
        build: () => speakerDetailBloc,
        act: (bloc) => bloc.add(const SpeakerLinkTapped(url: 'invalid-url')),
        verify: (_) {
          verifyNever(() => urlLauncher.launchUrl(url: any(named: 'url')));
        },
      );

      blocTest<SpeakerDetailBloc, SpeakerDetailState>(
        'emits [BlogDetailFailure] when url launcher throws exception',
        setUp: () {
          when(() => urlLauncher.validateUrl(url: any(named: 'url')))
              .thenThrow(TestData.error);
        },
        build: () => speakerDetailBloc,
        act: (bloc) => bloc.add(const SpeakerLinkTapped(url: 'invalid-url')),
        expect: () => [
          isA<SpeakerDetailError>().having(
            (state) => state.error,
            'error',
            equals(TestData.error),
          ),
        ],
      );
    });
  });
}
