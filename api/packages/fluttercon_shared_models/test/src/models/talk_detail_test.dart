import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TalkDetail', () {
    test('supports value equality', () {
      expect(
        TalkDetail(
          id: '1',
          title: 'title',
          description: 'description',
          room: 'room',
          speakers: const [],
          startTime: DateTime(2024),
        ),
        equals(
          TalkDetail(
            id: '1',
            title: 'title',
            description: 'description',
            room: 'room',
            speakers: const [],
            startTime: DateTime(2024),
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final talkDetail = TalkDetail.fromJson(TestHelpers.talkDetailJson);
        expect(
          talkDetail,
          equals(TestHelpers.talkDetail),
        );
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.talkDetail.toJson();
        expect(
          json,
          equals(TestHelpers.talkDetailJson),
        );
      });
    });
  });
}
