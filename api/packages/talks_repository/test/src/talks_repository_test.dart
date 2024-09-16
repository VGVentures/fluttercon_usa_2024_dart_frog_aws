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
      setUp(() {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        when(
          () => dataSource.createFavoritesTalk(
            favoritesId: TestHelpers.favoritesId,
            talkId: TestHelpers.createFavoriteRequest.talkId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks.items.first!);
        when(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).thenAnswer((_) async => TestHelpers.favorites.items.first!);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
      });
      test('fetches $Favorites from cache when present', () async {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));

        await talksRepository.createFavorite(
          request: TestHelpers.createFavoriteRequest,
        );

        verifyNever(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        );
        verifyNever(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        );
      });

      test('calls api and caches when $Favorites not present in cache',
          () async {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => null);

        await talksRepository.createFavorite(
          request: TestHelpers.createFavoriteRequest,
        );

        verify(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favCacheKey,
            any<String>(),
          ),
        ).called(2);
      });

      test('returns $CreateFavoriteResponse when successful', () async {
        final result = await talksRepository.createFavorite(
          request: TestHelpers.createFavoriteRequest,
        );
        expect(result, equals(TestHelpers.createFavoriteResponse));
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
      final favoritesTalk = TestHelpers.favoritesTalkSingle.items.first!;

      setUp(() {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        when(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).thenAnswer((_) async => TestHelpers.favorites.items.first!);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
            talkId: TestHelpers.talks.items.first!.id,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalkSingle);
        when(
          () => dataSource.deleteFavoritesTalk(
            id: favoritesTalk.id,
          ),
        ).thenAnswer((_) async => favoritesTalk);
      });

      test('fetches $Favorites from cache when present', () async {
        await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );

        verifyNever(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        );
        verifyNever(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        );
      });

      test('calls api and caches when $Favorites not present in cache',
          () async {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => null);
        await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );

        verify(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favCacheKey,
            any<String>(),
          ),
        ).called(2);
      });

      test('returns $DeleteFavoriteResponse when successful', () async {
        final result = await talksRepository.deleteFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );
        expect(result, equals(TestHelpers.deleteFavoriteResponse));
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
            talkId: TestHelpers.talks.items.first!.id,
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
            talkId: TestHelpers.talks.items.first!.id,
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
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).thenAnswer((_) async => TestHelpers.favorites.items.first!);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);
        final talks = TestHelpers.talks.items;
        when(() => dataSource.getSpeakerTalks(talk: talks[0])).thenAnswer(
          (_) async => TestHelpers.speakerTalks(talks[0]!),
        );
        when(() => dataSource.getSpeakerTalks(talk: talks[1])).thenAnswer(
          (_) async => TestHelpers.speakerTalks(talks[1]!),
        );
        when(() => dataSource.getSpeakerTalks(talk: talks[2])).thenAnswer(
          (_) async => TestHelpers.speakerTalks(talks[2]!),
        );
      });

      test('fetches $Favorites from cache when present', () async {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        await talksRepository.getFavorites(
          userId: userId,
        );

        final result = await talksRepository.getFavorites(userId: userId);
        expect(result, equals(TestHelpers.talkTimeSlots));
        verifyNever(
          () => dataSource.createFavorites(
            userId: userId,
          ),
        );
      });

      test('calls api and caches when $Favorites not present in cache',
          () async {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => null);

        await talksRepository.getFavorites(
          userId: userId,
        );

        verify(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favCacheKey,
            any<String>(),
          ),
        ).called(1);
      });

      test('does not return $TalkTimeSlot when talk data is null', () async {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => null);
        when(() => dataSource.getFavorites(userId: userId)).thenAnswer(
          (_) async => TestHelpers.favorites,
        );

        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: any(named: 'favoritesId'),
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

        final result = await talksRepository.getFavorites(userId: userId);
        expect(result.items, isEmpty);
      });
    });

    group('getTalks', () {
      setUp(() {
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => jsonEncode(TestHelpers.favoritesJson));
        final talks = TestHelpers.talks.items;
        when(() => dataSource.getSpeakerTalks(talk: talks[0])).thenAnswer(
          (_) async => TestHelpers.speakerTalks(talks[0]!),
        );
        when(() => dataSource.getSpeakerTalks(talk: talks[1])).thenAnswer(
          (_) async => TestHelpers.speakerTalks(talks[1]!),
        );
        when(() => dataSource.getSpeakerTalks(talk: talks[2])).thenAnswer(
          (_) async => TestHelpers.speakerTalks(talks[2]!),
        );
      });

      test('fetches $Talk data from cache when available', () async {
        when(() => cache.get(talksCacheKey)).thenAnswer(
          (_) async => jsonEncode(TestHelpers.talksJson),
        );

        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        verifyNever(() => dataSource.getTalks());
        expect(result, equals(TestHelpers.talkTimeSlots));
      });

      test('calls api and caches when $Talk data is not in cache', () async {
        when(() => cache.get(talksCacheKey)).thenAnswer(
          (_) async => null,
        );
        when(() => dataSource.getTalks())
            .thenAnswer((_) async => TestHelpers.talks);

        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        verify(
          () => dataSource.getTalks(),
        ).called(1);
        verify(
          () => cache.set(
            talksCacheKey,
            any<String>(),
          ),
        ).called(1);
        expect(result, equals(TestHelpers.talkTimeSlots));
      });

      test('calls api and caches when $Favorites data is not in cache',
          () async {
        when(() => cache.get(talksCacheKey)).thenAnswer(
          (_) async => jsonEncode(TestHelpers.talksJson),
        );
        when(
          () => cache.get(
            favCacheKey,
          ),
        ).thenAnswer((_) async => null);
        when(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).thenAnswer((_) async => TestHelpers.favorites.items.first!);
        when(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).thenAnswer((_) async => TestHelpers.favoritesTalks);

        await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );

        verify(
          () => dataSource.createFavorites(
            userId: TestHelpers.userId,
          ),
        ).called(1);
        verify(
          () => dataSource.getFavoritesTalks(
            favoritesId: TestHelpers.favoritesId,
          ),
        ).called(1);
        verify(
          () => cache.set(
            favCacheKey,
            any<String>(),
          ),
        ).called(1);
      });

      test('does not return $TalkTimeSlot when talk data is null', () async {
        when(() => cache.get(talksCacheKey)).thenAnswer(
          (_) async => null,
        );
        when(() => dataSource.getTalks()).thenAnswer(
          (_) async => PaginatedResult(
            [null],
            null,
            null,
            null,
            Talk.classType,
            null,
          ),
        );

        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        expect(result.items, isEmpty);
      });
    });
  });
}
