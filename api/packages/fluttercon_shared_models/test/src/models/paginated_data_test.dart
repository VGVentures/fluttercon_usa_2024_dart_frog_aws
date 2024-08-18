// ignore_for_file: prefer_const_constructors

import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('PaginatedData', () {
    test('supports value equality', () {
      expect(
        PaginatedData(
          items: const [1, 2, 3],
          limit: 3,
          nextToken: 'token',
        ),
        equals(
          PaginatedData(
            items: const [1, 2, 3],
            limit: 3,
            nextToken: 'token',
          ),
        ),
      );
    });
    group('fromJson', () {
      test('can be created from valid JSON', () {
        final data = PaginatedData.fromJson(
          TestHelpers.paginatedDataJson,
          (json) => json! as int,
        );
        expect(data, equals(TestHelpers.paginatedData));
      });
    });

    group('toJson', () {
      test('can be serialized to JSON', () {
        final json = TestHelpers.paginatedData.toJson((item) => item);
        expect(json, equals(TestHelpers.paginatedDataJson));
      });
    });
  });
}
