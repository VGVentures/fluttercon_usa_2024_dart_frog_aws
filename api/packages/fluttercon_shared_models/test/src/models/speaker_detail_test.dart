// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('SpeakerDetail', () {
    test('supports value equality', () {
      expect(
        SpeakerDetail(
          id: '1',
          name: 'John Doe',
          title: 'Speaker',
          bio: 'A person',
          imageUrl: 'https://example.com',
          links: const [],
          talks: const [],
        ),
        equals(
          SpeakerDetail(
            id: '1',
            name: 'John Doe',
            title: 'Speaker',
            bio: 'A person',
            imageUrl: 'https://example.com',
            links: const [],
            talks: const [],
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final speakerDetail =
            SpeakerDetail.fromJson(TestHelpers.speakerDetailJson);
        expect(speakerDetail, equals(TestHelpers.speakerDetail));
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.speakerDetail.toJson();
        expect(json, equals(TestHelpers.speakerDetailJson));
      });
    });
  });
}
