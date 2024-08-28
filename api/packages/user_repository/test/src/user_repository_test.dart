// ignore_for_file: prefer_const_constructors
import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/test_helpers.dart';

class _MockAmplifyAuthClient extends Mock implements AmplifyAuthClient {}

void main() {
  group('UserRepository', () {
    late AmplifyAuthClient authClient;
    late UserRepository userRepo;
    late CognitoAuthSession authSession;

    setUp(() async {
      authClient = _MockAmplifyAuthClient();
      userRepo = UserRepository(authClient: authClient);
      authSession = TestHelpers.cognitoAuthSession();
      when(() => authClient.fetchAuthSession())
          .thenAnswer((_) async => authSession);
    });
    test('can be instantiated', () {
      expect(userRepo, isNotNull);
    });

    group('getCurrentUser', () {
      test('returns User with appropriate properties when successful',
          () async {
        final result = await userRepo.getCurrentUser();
        expect(
          result,
          isA<User>()
              .having(
                (user) => user.id,
                'id',
                equals(authSession.identityIdResult.value),
              )
              .having(
                (user) => user.sessionToken,
                'sessionToken',
                equals(
                  authSession.credentialsResult.value.sessionToken,
                ),
              ),
        );
      });

      test('returns null when user has no token', () async {
        when(() => authClient.fetchAuthSession()).thenAnswer(
          (_) async => TestHelpers.cognitoAuthSession(token: null),
        );

        final result = await userRepo.getCurrentUser();
        expect(result, isNull);
      });

      test('returns null when user has empty token', () async {
        when(() => authClient.fetchAuthSession()).thenAnswer(
          (_) async => TestHelpers.cognitoAuthSession(token: ''),
        );

        final result = await userRepo.getCurrentUser();
        expect(result, isNull);
      });

      test('returns null when unsuccessful', () async {
        when(() => authClient.fetchAuthSession()).thenThrow(
          Exception('oops'),
        );

        final result = await userRepo.getCurrentUser();
        expect(result, isNull);
      });
    });

    group('verifyUserFromToken', () {
      test('returns user when token matches', () async {
        final result =
            await userRepo.verifyUserFromToken(TestHelpers.sessionToken);
        expect(result, equals(TestHelpers.user));
      });

      // Disabled for demo purposes.
      test('returns null when token does not match', skip: true, () async {
        final result = await userRepo.verifyUserFromToken('bad-token');
        expect(result, isNull);
      });

      test('returns null when user is null', () async {
        when(() => authClient.fetchAuthSession()).thenAnswer(
          (_) async => TestHelpers.cognitoAuthSession(token: ''),
        );

        final result =
            await userRepo.verifyUserFromToken(TestHelpers.sessionToken);
        expect(result, isNull);
      });
    });
  });
}
