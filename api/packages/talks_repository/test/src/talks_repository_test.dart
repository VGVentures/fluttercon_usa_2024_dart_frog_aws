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
        ).thenAnswer((_) async => TestHelpers.speakerData);
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
        ).thenAnswer((_) async => TestHelpers.talksData);
        when(
          () => cache.getOrElse<PaginatedData<SpeakerTalk?>>(
            key: speakerTalksCacheKey(
              TestHelpers.talksData.items.map((e) => e?.id).join(','),
            ),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.speakerData);
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
      final talkDetail = TestHelpers.talkDetail;
      setUp(() {
        when(
          () => cache.getOrElse<TalkDetail>(
            key: talkCacheKey(talkDetail.id),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => talkDetail);
      });

      test('returns $TalkDetail', () async {
        final result = await talksRepository.getTalk(id: talkDetail.id);

        expect(result, equals(TestHelpers.talkDetail));
      });
    });

    group('getFavoritesFromApi', () {
      setUp(() {
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
      });

      test('fetches $Favorites from api and caches', () async {
        await talksRepository.getFavoritesFromApi(TestHelpers.userId);

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

    group('getSpeakersFromApi', () {
      setUp(() {
        when(() =>
                dataSource.getSpeakerTalks(talks: TestHelpers.talksData.items))
            .thenAnswer((_) async => TestHelpers.speakerResult);
        when(
          () => cache.set(
            speakerTalksCacheKey(
              TestHelpers.talksData.items.map((e) => e?.id).join(','),
            ),
            any(),
          ),
        ).thenAnswer((_) async => {});
      });

      test('fetches $SpeakerTalk data from api and caches', () async {
        await talksRepository.getSpeakersFromApi(
          TestHelpers.talksData.items,
        );
        verify(
          () => dataSource.getSpeakerTalks(talks: TestHelpers.talksData.items),
        ).called(1);
        verify(
          () => cache.set(
            speakerTalksCacheKey(
              TestHelpers.talksData.items.map((e) => e?.id).join(','),
            ),
            any(),
          ),
        ).called(1);
      });
    });

    group('getTalksFromApi', () {
      setUp(() {
        when(() => dataSource.getTalks())
            .thenAnswer((_) async => TestHelpers.talksResult);
        when(
          () => cache.set(
            talksCacheKey,
            any(),
          ),
        ).thenAnswer((_) async => {});
      });

      test('fetches $Talk data from api and caches', () async {
        await talksRepository.getTalksFromApi();

        verify(
          () => dataSource.getTalks(),
        ).called(1);
        verify(
          () => cache.set(talksCacheKey, any()),
        ).called(1);
      });
    });

    group('getTalkDetailFromApi', () {
      final talk = TestHelpers.talks[0]!;
      setUp(() {
        when(() => dataSource.getTalk(id: talk.id))
            .thenAnswer((_) async => talk);
        when(() => dataSource.getSpeakerTalks(talks: [talk]))
            .thenAnswer((_) async => TestHelpers.speakerResult);
        when(
          () => cache.set(
            talkCacheKey(talk.id),
            any(),
          ),
        ).thenAnswer((_) async => {});
      });

      test('fetches $TalkDetail from api and caches', () async {
        await talksRepository.getTalkDetailFromApi(talk.id);

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
