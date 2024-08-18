// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('SpeakerPreview', () {
    test('supports value equality', () {
      expect(
        SpeakerPreview(
          id: '1',
          name: 'John Doe',
          title: 'Speaker',
          imageUrl: 'https://example.com',
        ),
        equals(
          SpeakerPreview(
            id: '1',
            name: 'John Doe',
            title: 'Speaker',
            imageUrl: 'https://example.com',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final speakerPreview =
            SpeakerPreview.fromJson(TestHelpers.speakerPreviewJson);
        expect(speakerPreview, equals(TestHelpers.speakerPreview));
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.speakerPreview.toJson();
        expect(json, equals(TestHelpers.speakerPreviewJson));
      });
    });
  });
}
