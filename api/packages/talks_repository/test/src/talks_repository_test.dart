// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talks_repository/talks_repository.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockFlutterconDataSource extends Mock implements FlutterconDataSource {}

class _MockFlutterconCache extends Mock implements FlutterconCache {}

void main() {
  group('TalksRepository', () {
    late FlutterconDataSource dataSource;
    late FlutterconCache cache;
    late TalksRepository talksRepository;
    late String favCacheKey;

    setUp(() {
      dataSource = _MockFlutterconDataSource();
      cache = _MockFlutterconCache();
      talksRepository = TalksRepository(dataSource: dataSource, cache: cache);
      when(() => cache.set(talksCacheKey, any<String>())).thenAnswer(
        (_) async => {},
      );
      favCacheKey = favoritesCacheKey(TestHelpers.userId);
      when(() => cache.set(favCacheKey, any())).thenAnswer(
        (_) async => {},
      );
    });

    setUpAll(() {
      registerFallbackValue(
        PaginatedData<Favorites>(
          items: const [],
        ),
      );
      registerFallbackValue(
        PaginatedData<Talk>(
          items: const [],
        ),
      );
    });

    test('can be instantiated', () {
      expect(talksRepository, isNotNull);
    });

    group('createFavorite', () {
      final request = TestHelpers.createFavoriteRequest;
      setUp(() {
        when(
          () => cache.get(
            favoritesCacheKey(request.userId),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        when(
          () => dataSource.createFavoritesTalk(
            favoritesId: TestHelpers.favoritesId,
            talkId: TestHelpers.createFavoriteRequest.talkId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks.items.first!);
      });

      test('returns $CreateFavoriteResponse when successful', () async {
        final result = await talksRepository.createFavorite(
          request: TestHelpers.createFavoriteRequest,
        );
        expect(result, equals(TestHelpers.createFavoriteResponse));
      });

      test('fetches $Favorites from api when not cached', () async {
        when(
          () => cache.get(
            favoritesCacheKey(request.userId),
          ),
        ).thenAnswer((_) async => null);
        when(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).thenAnswer((_) async => TestHelpers.favorites);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
        when(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.createFavorite(
          request: TestHelpers.createFavoriteRequest,
        );
        expect(result, equals(TestHelpers.createFavoriteResponse));

        verify(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).called(2);
      });

      test('updates cached $Favorites when successful', () async {
        await talksRepository.createFavorite(
          request: TestHelpers.createFavoriteRequest,
        );

        verify(
          () => cache.set(
            favCacheKey,
            any<String>(),
          ),
        ).called(1);
      });
    });

    group('deleteFavorite', () {
      final request = TestHelpers.deleteFavoriteRequest;
      final favoritesTalk = TestHelpers.favoritesTalkSingle.items.first!;
      setUp(() {
        when(
          () => cache.get(
            favoritesCacheKey(request.userId),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
            talkId: request.talkId,
          ),
        ).thenAnswer(
          (_) async => TestHelpers.favoritesTalkSingle,
        );
        when(
          () => dataSource.deleteFavoritesTalk(
            id: favoritesTalk.id,
          ),
        ).thenAnswer((_) async => favoritesTalk);
      });

      test('returns $DeleteFavoriteResponse when successful', () async {
        final result = await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );
        expect(result, equals(TestHelpers.deleteFavoriteResponse));
      });

      test('fetches $Favorites from api when not cached', () async {
        when(
          () => cache.get(
            favoritesCacheKey(request.userId),
          ),
        ).thenAnswer((_) async => null);

        when(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).thenAnswer((_) async => TestHelpers.favorites);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
        when(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );
        expect(result, equals(TestHelpers.deleteFavoriteResponse));

        verify(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).called(2);
      });

      test('updates cached $Favorites when successful', () async {
        await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );

        verify(
          () => cache.set(
            favCacheKey,
            any<String>(),
          ),
        ).called(1);
      });

      test(
          'returns $DeleteFavoriteRequest without calling api '
          'when favoritesTalk data is null', () async {
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
            talkId: TestHelpers.talksData.items.first!.id,
          ),
        ).thenAnswer(
          (_) async => PaginatedResult(
            [null],
            null,
            null,
            null,
            FavoritesTalk.classType,
            null,
          ),
        );

        final result = await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );
        expect(result, equals(TestHelpers.deleteFavoriteResponse));
        verifyNever(
          () => dataSource.deleteFavoritesTalk(
            id: favoritesTalk.id,
          ),
        );
      });

      test(
          'returns $DeleteFavoriteRequest without calling api '
          'when favoritesTalk data is empty', () async {
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
            talkId: TestHelpers.talksData.items.first!.id,
          ),
        ).thenAnswer(
          (_) async => PaginatedResult(
            [],
            null,
            null,
            null,
            FavoritesTalk.classType,
            null,
          ),
        );

        final result = await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );
        expect(result, equals(TestHelpers.deleteFavoriteResponse));
        verifyNever(
          () => dataSource.deleteFavoritesTalk(
            id: favoritesTalk.id,
          ),
        );
      });
    });

    group('getFavorites', () {
      const userId = 'userId';

      setUp(() {
        when(
          () => cache.get(
            favoritesCacheKey(TestHelpers.userId),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        when(
          () => cache.get(
            speakerTalksCacheKey(
              TestHelpers.favorites.talks!.map((e) => e.talk!.id).join(','),
            ),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.speakerDataJson));
      });

      test('returns $TalkTimeSlot data', () async {
        final result = await talksRepository.getFavorites(userId: userId);
        expect(result, equals(TestHelpers.talkTimeSlots));
      });

      test('fetches $Favorites from api when not cached', () async {
        when(
          () => cache.get(
            favoritesCacheKey(TestHelpers.userId),
          ),
        ).thenAnswer((_) async => null);
        when(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).thenAnswer((_) async => TestHelpers.favorites);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
        when(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.getFavorites(userId: userId);
        expect(result, equals(TestHelpers.talkTimeSlots));

        verify(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).called(1);
      });

      test('fetches $SpeakerTalk data from api when not cached', () async {
        final talks =
            TestHelpers.talksData.items.where((e) => e != null).toList();

        when(
          () => cache.get(
            speakerTalksCacheKey(
              TestHelpers.favorites.talks!.map((e) => e.talk!.id).join(','),
            ),
          ),
        ).thenAnswer((_) async => null);
        when(
          () => dataSource.getSpeakerTalks(
            talks: talks,
          ),
        ).thenAnswer((_) async => TestHelpers.speakerResult);
        when(
          () => cache.set(
            speakerTalksCacheKey(
              TestHelpers.talksData.items
                  .where((e) => e != null)
                  .map((e) => e!.id)
                  .join(','),
            ),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.getFavorites(userId: userId);
        expect(result, equals(TestHelpers.talkTimeSlots));

        verify(
          () => dataSource.getSpeakerTalks(talks: talks),
        ).called(1);
        verify(
          () => cache.set(
            speakerTalksCacheKey(
              TestHelpers.talksData.items
                  .where((e) => e != null)
                  .map((e) => e!.id)
                  .join(','),
            ),
            any(),
          ),
        ).called(1);
      });
    });

    group('getTalks', () {
      setUp(() {
        when(
          () => cache.get(
            talksCacheKey,
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.talksDataJson));
        when(
          () => cache.get(
            speakerTalksCacheKey(
              TestHelpers.talksData.items
                  .where((e) => e != null)
                  .map((e) => e?.id)
                  .join(','),
            ),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.speakerDataJson));
        when(
          () => cache.get(
            favoritesCacheKey(TestHelpers.userId),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
      });

      test('returns $TalkTimeSlot data', () async {
        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        expect(result, equals(TestHelpers.talkTimeSlots));
      });

      test('fetches $Talk data from api when not cached', () async {
        when(
          () => cache.get(
            talksCacheKey,
          ),
        ).thenAnswer((_) async => null);
        when(() => dataSource.getTalks())
            .thenAnswer((_) async => TestHelpers.talksResult);
        when(
          () => cache.get(
            speakerTalksCacheKey(
              TestHelpers.talksData.items.map((e) => e?.id).join(','),
            ),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.speakerDataJson));
        when(
          () => cache.set(
            talksCacheKey,
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        expect(result, equals(TestHelpers.talkTimeSlots));

        verify(
          () => dataSource.getTalks(),
        ).called(1);
        verify(
          () => cache.set(talksCacheKey, any()),
        ).called(1);
      });

      test('fetches $SpeakerTalk data from api when not cached', () async {
        final talks =
            TestHelpers.talksData.items.where((e) => e != null).toList();

        when(
          () => cache.get(
            speakerTalksCacheKey(
              TestHelpers.favorites.talks!.map((e) => e.talk!.id).join(','),
            ),
          ),
        ).thenAnswer((_) async => null);
        when(
          () => dataSource.getSpeakerTalks(
            talks: talks,
          ),
        ).thenAnswer((_) async => TestHelpers.speakerResult);
        when(
          () => cache.set(
            speakerTalksCacheKey(
              TestHelpers.talksData.items
                  .where((e) => e != null)
                  .map((e) => e!.id)
                  .join(','),
            ),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        expect(result, equals(TestHelpers.talkTimeSlots));

        verify(
          () => dataSource.getSpeakerTalks(talks: talks),
        ).called(1);
        verify(
          () => cache.set(
            speakerTalksCacheKey(
              TestHelpers.talksData.items
                  .where((e) => e != null)
                  .map((e) => e!.id)
                  .join(','),
            ),
            any(),
          ),
        ).called(1);
      });

      test('fetches $Favorites from api when not cached', () async {
        when(
          () => cache.get(
            favoritesCacheKey(TestHelpers.userId),
          ),
        ).thenAnswer((_) async => null);
        when(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).thenAnswer((_) async => TestHelpers.favorites);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
        when(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result =
            await talksRepository.getTalks(userId: TestHelpers.userId);

        expect(result, equals(TestHelpers.talkTimeSlots));

        verify(
          () => dataSource.createFavorites(userId: TestHelpers.userId),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favoritesCacheKey(TestHelpers.userId),
            any(),
          ),
        ).called(1);
      });
    });

    group('getTalk', () {
      final talkDetail = TestHelpers.talkDetail;
      setUp(() {
        when(
          () => cache.get(
            talkCacheKey(talkDetail.id),
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.talkDetailJson));
      });

      test('returns $TalkDetail', () async {
        final result = await talksRepository.getTalk(id: talkDetail.id);

        expect(result, equals(TestHelpers.talkDetail));
      });

      test('fetches $TalkDetail from api when not cached', () async {
        final talk = TestHelpers.talks[0]!;
        when(
          () => cache.get(
            talkCacheKey(talkDetail.id),
          ),
        ).thenAnswer((_) async => null);
        when(() => dataSource.getTalk(id: talk.id))
            .thenAnswer((_) async => talk);
        when(() => dataSource.getSpeakerTalks(talks: [talk]))
            .thenAnswer((_) async => TestHelpers.speakerTalksSingle);
        when(
          () => cache.set(
            talkCacheKey(talk.id),
            any(),
          ),
        ).thenAnswer((_) async => {});

        final result = await talksRepository.getTalk(id: talkDetail.id);
        expect(result, equals(TestHelpers.talkDetail));

        verify(
          () => dataSource.getTalk(id: talk.id),
        ).called(1);
        verify(
          () => dataSource.getSpeakerTalks(talks: [talk]),
        ).called(1);
        verify(
          () => cache.set(talkCacheKey(talk.id), any()),
        ).called(1);
      });
    });
  });
}
