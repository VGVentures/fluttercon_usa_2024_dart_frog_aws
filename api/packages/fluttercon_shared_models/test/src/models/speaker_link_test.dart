// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('SpeakerLink', () {
    test('supports value equality', () {
      expect(
        SpeakerLink(
          id: '1',
          url: 'https://example.com',
          type: SpeakerLinkType.other,
        ),
        equals(
          SpeakerLink(
            id: '1',
            url: 'https://example.com',
            type: SpeakerLinkType.other,
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final speakerLink = SpeakerLink.fromJson(TestHelpers.speakerLinkJson);
        expect(
          speakerLink,
          equals(TestHelpers.speakerLink),
        );
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.speakerLink.toJson();
        expect(
          json,
          equals(TestHelpers.speakerLinkJson),
        );
      });
    });
  });
}
