// ignore_for_file: prefer_const_constructors
import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class _MockAmplifyAuthClient extends Mock implements AmplifyAuthClient {}

void main() {
  group('UserRepository', () {
    late AmplifyAuthClient authClient;
    late UserRepository userRepo;
    const username = 'username';
    const userId = '123';

    final user = AuthUser(
      userId: userId,
      username: username,
      signInDetails: CognitoSignInDetailsApiBased(username: username),
    );

    setUp(() async {
      authClient = _MockAmplifyAuthClient();
      userRepo = UserRepository(authClient: authClient);
    });
    test('can be instantiated', () {
      expect(userRepo, isNotNull);
    });

    group('getCurrentUser', () {
      test('returns AuthUser when successful', () async {
        when(() => authClient.getCurrentUser()).thenAnswer((_) async => user);

        final result = await userRepo.getCurrentUser();
        expect(result, isA<AuthUser>());
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
