// ignore_for_file: prefer_const_constructors
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speakers_repository/speakers_repository.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockFlutterconDataSource extends Mock implements FlutterconDataSource {}

void main() {
  group('SpeakersRepository', () {
    late FlutterconDataSource dataSource;
    late SpeakersRepository speakersRepository;

    setUp(() {
      dataSource = _MockFlutterconDataSource();
      speakersRepository = SpeakersRepository(dataSource: dataSource);
    });

    test('can be instantiated', () {
      expect(speakersRepository, isNotNull);
    });

    group('getTalks', () {
      test('returns sorted ${PaginatedData<SpeakerPreview>} when successful',
          () async {
        when(() => dataSource.getSpeakers())
            .thenAnswer((_) async => TestHelpers.speakers);

        final result = await speakersRepository.getSpeakers();
        expect(result, equals(TestHelpers.speakerPreviews));
      });
    });
  });
}
