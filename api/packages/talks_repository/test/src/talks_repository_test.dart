// ignore_for_file: prefer_const_constructors
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talks_repository/talks_repository.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockFlutterconDataSource extends Mock implements FlutterconDataSource {}

void main() {
  group('TalksRepository', () {
    late FlutterconDataSource dataSource;
    late TalksRepository talksRepository;

    setUp(() {
      dataSource = _MockFlutterconDataSource();
      talksRepository = TalksRepository(dataSource: dataSource);
    });

    test('can be instantiated', () {
      expect(talksRepository, isNotNull);
    });

    group('getTalks', () {
      test('returns ${PaginatedData<TalkPreview>} when successful', () async {
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
        expect(result, equals(TestHelpers.talkPreviews));
      });

      test('does not return $TalkPreview when talk data is null', () async {
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
