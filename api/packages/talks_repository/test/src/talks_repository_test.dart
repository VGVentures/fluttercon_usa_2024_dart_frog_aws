// ignore_for_file: prefer_const_constructors
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
          () => cache.getOrElse<Favorites>(
            key: favoritesCacheKey(request.userId),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.favorites);
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
          () => cache.getOrElse<Favorites>(
            key: favoritesCacheKey(request.userId),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.favorites);
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
          () => cache.getOrElse<Favorites>(
            key: favoritesCacheKey(TestHelpers.userId),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.favorites);
        when(
          () => cache.getOrElse<PaginatedData<SpeakerTalk?>>(
            key: speakerTalksCacheKey(
              TestHelpers.favorites.talks!.map((e) => e.talk!.id).join(','),
            ),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.speakerTalks);
      });

      test('returns $TalkTimeSlot data', () async {
        final result = await talksRepository.getFavorites(userId: userId);
        expect(result, equals(TestHelpers.talkTimeSlots));
      });
    });

    group('getTalks', () {
      setUp(() {
        when(
          () => cache.getOrElse<PaginatedData<Talk?>>(
            key: talksCacheKey,
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.talks);
        when(
          () => cache.getOrElse<PaginatedData<SpeakerTalk?>>(
            key: speakerTalksCacheKey(
              TestHelpers.talks.items.map((e) => e?.id).join(','),
            ),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.speakerTalks);
        when(
          () => cache.getOrElse<Favorites>(
            key: favoritesCacheKey(TestHelpers.userId),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.favorites);
      });

      test('returns $TalkTimeSlot data', () async {
        final result = await talksRepository.getTalks(
          userId: TestHelpers.userId,
        );
        expect(result, equals(TestHelpers.talkTimeSlots));
      });
    });

    group('getTalk', () {
      final talk = TestHelpers.talks.items[0]!;
      setUp(() {
        when(
          () => cache.getOrElse<Talk>(
            key: talkCacheKey(talk.id),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => talk);
      });

      test('returns $TalkDetail', () async {
        final result = await talksRepository.getTalk(id: talk.id);

        expect(result, equals(TestHelpers.talkDetail));
      });
    });
  });
}
