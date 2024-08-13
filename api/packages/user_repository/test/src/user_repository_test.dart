// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/test_helpers.dart';

class _MockAmplifyAuthClient extends Mock implements AmplifyAuthClient {}

void main() {
  group('UserRepository', () {
    late AmplifyAuthClient authClient;
    late UserRepository userRepo;

    setUp(() async {
      authClient = _MockAmplifyAuthClient();
      userRepo = UserRepository(authClient: authClient);
    });
    test('can be instantiated', () {
      expect(userRepo, isNotNull);
    });

    group('getCurrentUser', () {
      test('returns User when successful', () async {
        when(() => authClient.getCurrentUser())
            .thenAnswer((_) async => TestHelpers.amplifyUser);
        when(() => authClient.getSessionToken())
            .thenAnswer((_) async => TestHelpers.sessionToken);

        final result = await userRepo.getCurrentUser();
        expect(result, isA<User>());
      });

      test('can return existing user without calling api', () async {
        final repositoryWithUser = UserRepository(
          authClient: authClient,
          currentUser: User(
            id: TestHelpers.userId,
            sessionToken: TestHelpers.sessionToken,
          ),
        );

        final result = await repositoryWithUser.getCurrentUser();
        expect(result, isA<User>());
        verifyNever(() => authClient.getCurrentUser());
        verifyNever(() => authClient.getSessionToken());
      });

      test('returns null when no user is found', () async {
        when(() => authClient.getCurrentUser()).thenAnswer((_) async => null);

        final result = await userRepo.getCurrentUser();
        expect(result, isNull);
      });

      test('throws AmplifyAuthException when session token is empty', () async {
        when(() => authClient.getCurrentUser()).thenAnswer(
          (_) async => TestHelpers.amplifyUser,
        );
        when(() => authClient.getSessionToken()).thenAnswer((_) async => '');

        expect(
          () async => userRepo.getCurrentUser(),
          throwsA(isA<AmplifyAuthException>()),
        );
      });

      test('throws AmplifyAuthException when unsuccessful', () async {
        when(() => authClient.getCurrentUser()).thenThrow(
          Exception('oops'),
        );

        expect(
          () async => userRepo.getCurrentUser(),
          throwsA(isA<AmplifyAuthException>()),
        );
      });
    });
  });
}
