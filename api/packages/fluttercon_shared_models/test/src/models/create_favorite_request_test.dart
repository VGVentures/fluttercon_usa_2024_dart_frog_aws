// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/src/models/models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('CreateFavoriteRequest', () {
    test('supports value equality', () {
      expect(
        CreateFavoriteRequest(
          userId: '1',
          talkId: '1',
        ),
        equals(
          CreateFavoriteRequest(
            userId: '1',
            talkId: '1',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can be created from valid JSON', () {
        final request = CreateFavoriteRequest.fromJson(
          TestHelpers.createFavoriteRequestJson,
        );
        expect(
          request,
          equals(
            TestHelpers.createFavoriteRequest,
          ),
        );
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.createFavoriteRequest.toJson();
        expect(json, equals(TestHelpers.createFavoriteRequestJson));
      });
    });
  });
}
