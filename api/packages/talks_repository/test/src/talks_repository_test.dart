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

    setUp(() {
      dataSource = _MockFlutterconDataSource();
      cache = _MockFlutterconCache();
      talksRepository = TalksRepository(dataSource: dataSource, cache: cache);
      when(() => cache.set(talksCacheKey, any<String>())).thenAnswer(
        (_) async => {},
      );
    });

    setUpAll(() {
      registerFallbackValue(
        PaginatedData<TalkTimeSlot>(
          items: const [],
        ),
      );
    });

    test('can be instantiated', () {
      expect(talksRepository, isNotNull);
    });

    group('getTalks', () {
      test('returns cached ${PaginatedData<TalkTimeSlot>} when available',
          () async {
        when(() => cache.get(talksCacheKey)).thenAnswer(
          (_) async => jsonEncode(TestHelpers.talkTimeSlotsJson),
        );

        final result = await talksRepository.getTalks();
        verifyNever(() => dataSource.getTalks());
        expect(result, equals(TestHelpers.talkTimeSlots));
      });

      test(
          'returns ${PaginatedData<TalkTimeSlot>} from api when not cached '
          'and adds to the cache', () async {
        when(() => cache.get(talksCacheKey)).thenAnswer(
          (_) async => null,
        );
        when(() => dataSource.getTalks())
            .thenAnswer((_) async => TestHelpers.talks);
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

        final result = await talksRepository.getTalks();
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

        final result = await talksRepository.getTalks();
        expect(result.items, isEmpty);
      });
    });
  });
}
