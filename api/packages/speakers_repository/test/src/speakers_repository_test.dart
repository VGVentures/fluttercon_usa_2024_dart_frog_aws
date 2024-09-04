// ignore_for_file: prefer_const_constructors
import 'dart:convert';

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
      when(() => cache.set(speakersCacheKey, any<String>())).thenAnswer(
        (_) async => {},
      );
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

    group('getTalks', () {
      test('returns cached ${PaginatedData<SpeakerPreview>} when available',
          () async {
        when(() => cache.get(speakersCacheKey)).thenAnswer(
          (_) async => jsonEncode(TestHelpers.speakerPreviewsJson),
        );

        final result = await speakersRepository.getSpeakers();
        verifyNever(() => dataSource.getSpeakers());
        expect(result, equals(TestHelpers.speakerPreviews));
      });

      test(
          'returns ${PaginatedData<SpeakerPreview>} from api when not cached '
          'and adds to the cache', () async {
        when(() => cache.get(speakersCacheKey)).thenAnswer(
          (_) async => null,
        );
        when(() => dataSource.getSpeakers())
            .thenAnswer((_) async => TestHelpers.speakers);

        final result = await speakersRepository.getSpeakers();
        verify(
          () => dataSource.getSpeakers(),
        ).called(1);
        verify(
          () => cache.set(
            speakersCacheKey,
            any<String>(),
          ),
        ).called(1);
        expect(result, equals(TestHelpers.speakerPreviews));
      });
    });
  });
}
