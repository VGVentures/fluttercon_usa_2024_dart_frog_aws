// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speakers_repository/speakers_repository.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockFlutterconDataSource extends Mock implements FlutterconDataSource {}

class _MockFlutterconCache extends Mock implements FlutterconCache {}

void main() {
  group('SpeakersRepository', () {
    late FlutterconDataSource dataSource;
    late FlutterconCache cache;
    late SpeakersRepository speakersRepository;

    setUp(() {
      dataSource = _MockFlutterconDataSource();
      cache = _MockFlutterconCache();
      speakersRepository =
          SpeakersRepository(dataSource: dataSource, cache: cache);
    });

    setUpAll(() {
      registerFallbackValue(
        PaginatedData<SpeakerPreview>(
          items: const [],
        ),
      );
    });

    test('can be instantiated', () {
      expect(speakersRepository, isNotNull);
    });

    group('getSpeakers', () {
      setUp(() {
        when(
          () => cache.getOrElse<PaginatedData<SpeakerPreview>>(
            key: speakersCacheKey,
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.speakerPreviews);
      });

      test('returns $SpeakerPreview list', () async {
        final speakers = await speakersRepository.getSpeakers();
        expect(speakers, equals(TestHelpers.speakerPreviews));
      });
    });

    group('getSpeaker', () {
      setUp(() {
        when(
          () => cache.getOrElse<SpeakerDetail>(
            key: speakerCacheKey(TestHelpers.speakers.items[0]!.id),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.speakerDetail);
      });

      test('returns $SpeakerDetail', () async {
        final speakers = await speakersRepository.getSpeaker(
          id: TestHelpers.speakers.items[0]!.id,
          userId: TestHelpers.userId,
        );
        expect(speakers, equals(TestHelpers.speakerDetail));
      });
    });

    group('getSpeakersFromApi', () {
      setUp(() {
        when(() => dataSource.getSpeakers())
            .thenAnswer((_) async => TestHelpers.speakers);
        when(() => cache.set(speakersCacheKey, any<String>())).thenAnswer(
          (_) async => {},
        );
      });

      test('fetches $Speaker list from api and caches', () async {
        await speakersRepository.getSpeakersFromApi();
        verify(
          () => dataSource.getSpeakers(),
        ).called(1);
        verify(
          () => cache.set(
            speakersCacheKey,
            any<String>(),
          ),
        ).called(1);
      });
    });

    group('getSpeakerDetailFromApi', () {
      final speaker = TestHelpers.speakers.items[0]!;
      setUp(() {
        when(() => dataSource.getSpeaker(id: speaker.id))
            .thenAnswer((_) async => speaker);
        when(() => dataSource.getLinks(speaker: speaker))
            .thenAnswer((_) async => TestHelpers.links);
        when(() => dataSource.getSpeakerTalks(speakers: [speaker]))
            .thenAnswer((_) async => TestHelpers.talks);
        when(() => dataSource.getSpeakerTalks(talks: [TestHelpers.talk]))
            .thenAnswer((_) async => TestHelpers.talks);
        when(
          () => cache.getOrElse<Favorites?>(
            key: favoritesCacheKey(TestHelpers.userId),
            fromJson: any(named: 'fromJson'),
            orElse: any(named: 'orElse'),
          ),
        ).thenAnswer((_) async => TestHelpers.favorites);
        when(() => cache.set(speakerCacheKey(speaker.id), any()))
            .thenAnswer((_) async => {});
      });

      test('fetches $SpeakerDetail from api and caches', () async {
        await speakersRepository.getSpeakerDetailFromApi(
          id: speaker.id,
          userId: TestHelpers.userId,
        );
        verify(
          () => dataSource.getSpeaker(id: speaker.id),
        ).called(1);
        verify(
          () => dataSource.getLinks(speaker: speaker),
        ).called(1);
        verify(
          () => dataSource.getSpeakerTalks(speakers: [speaker]),
        ).called(1);
        verify(
          () => dataSource.getSpeakerTalks(talks: [TestHelpers.talk]),
        ).called(1);
        verify(
          () => cache.set(
            speakerCacheKey(speaker.id),
            any(),
          ),
        ).called(1);
      });
    });
  });
}
