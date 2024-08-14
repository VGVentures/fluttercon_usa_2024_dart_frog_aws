// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('User', () {
    test('can be instantiated', () {
      expect(
        TestHelpers.user,
        isNotNull,
      );
    });

    test('supports value equality', () {
      expect(
        User(
          id: '1',
          sessionToken: 'abc',
        ),
        equals(
          User(
            id: '1',
            sessionToken: 'abc',
          ),
        ),
      );
    });

    group('fromJson', () {
      test('can create User from json', () {
        final user = User.fromJson(TestHelpers.userJson);

        expect(
          user,
          isA<User>()
              .having((user) => user.id, 'id', TestHelpers.userId)
              .having(
                (user) => user.sessionToken,
                'sessionToken',
                TestHelpers.sessionToken,
              ),
        );
      });
    });

    group('toJson', () {
      test('can convert User to json', () {
        expect(
          TestHelpers.user.toJson(),
          equals(TestHelpers.userJson),
        );
      });
    });
  });
}
