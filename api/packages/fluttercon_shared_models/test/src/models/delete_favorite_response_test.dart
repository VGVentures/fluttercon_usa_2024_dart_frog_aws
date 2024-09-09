// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/src/models/models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('DeleteFavoriteResponse', () {
    test('supports value equality', () {
      expect(
        DeleteFavoriteResponse(
          userId: '1',
          talkId: '1',
        ),
        equals(
          DeleteFavoriteResponse(
            userId: '1',
            talkId: '1',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final response = DeleteFavoriteResponse.fromJson(
          TestHelpers.deleteFavoriteResponseJson,
        );
        expect(
          response,
          equals(
            TestHelpers.deleteFavoriteResponse,
          ),
        );
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.deleteFavoriteResponse.toJson();
        expect(json, equals(TestHelpers.deleteFavoriteResponseJson));
      });
    });
  });
}