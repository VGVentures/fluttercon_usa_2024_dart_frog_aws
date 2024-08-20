import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TalkTimeSlot', () {
    test('supports value equality', () {
      expect(
        TalkTimeSlot(
          startTime: DateTime(2024),
          talks: const [],
        ),
        equals(
          TalkTimeSlot(
            startTime: DateTime(2024),
            talks: const [],
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final talkTimeSlot =
            TalkTimeSlot.fromJson(TestHelpers.talkTimeSlotJson);
        expect(talkTimeSlot, equals(TestHelpers.talkTimeSlot));
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.talkTimeSlot.toJson();
        expect(json, equals(TestHelpers.talkTimeSlotJson));
      });
    });
  });
}
