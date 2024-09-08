// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/src/models/models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DeleteFavoriteRequest', () {
    test('supports value equality', () {
      expect(
        DeleteFavoriteRequest(
          userId: '1',
          talkId: '1',
        ),
        equals(
          DeleteFavoriteRequest(
            userId: '1',
            talkId: '1',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final request = DeleteFavoriteRequest.fromJson(
          TestHelpers.deleteFavoriteRequestJson,
        );
        expect(
          request,
          equals(
            TestHelpers.deleteFavoriteRequest,
          ),
        );
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.deleteFavoriteRequest.toJson();
        expect(json, equals(TestHelpers.deleteFavoriteRequestJson));
      });
    });
  });
}
