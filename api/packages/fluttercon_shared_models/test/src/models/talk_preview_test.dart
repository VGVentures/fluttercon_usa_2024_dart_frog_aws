import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TalkPreview', () {
    test('supports value equality', () {
      expect(
        TalkPreview(
          id: '1',
          title: 'title',
          room: 'room',
          speakerNames: const [],
          startTime: DateTime(2024),
          isFavorite: false,
        ),
        equals(
          TalkPreview(
            id: '1',
            title: 'title',
            room: 'room',
            speakerNames: const [],
            startTime: DateTime(2024),
            isFavorite: false,
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final talkPreview = TalkPreview.fromJson(TestHelpers.talkPreviewJson);
        expect(talkPreview, equals(TestHelpers.talkPreview));
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.talkPreview.toJson();
        expect(json, equals(TestHelpers.talkPreviewJson));
      });
    });
  });
}
