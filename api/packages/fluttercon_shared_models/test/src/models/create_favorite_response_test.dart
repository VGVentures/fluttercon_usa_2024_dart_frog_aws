// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/src/models/models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('CreateFavoriteResponse', () {
    test('supports value equality', () {
      expect(
        CreateFavoriteResponse(
          userId: '1',
          talkId: '1',
        ),
        equals(
          CreateFavoriteResponse(
            userId: '1',
            talkId: '1',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final response = CreateFavoriteResponse.fromJson(
          TestHelpers.createFavoriteResponseJson,
        );
        expect(
          response,
          equals(
            TestHelpers.createFavoriteResponse,
          ),
        );
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.createFavoriteResponse.toJson();
        expect(json, equals(TestHelpers.createFavoriteResponseJson));
      });
    });
  });
}
