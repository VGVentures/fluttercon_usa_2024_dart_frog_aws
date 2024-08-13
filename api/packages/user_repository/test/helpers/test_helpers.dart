import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:amplify_core/amplify_core.dart';

class TestHelpers {
  static const sessionToken = 'sessionToken';
  static const userId = '123';
  static const username = 'username';

  static const amplifyUser = AuthUser(
    userId: userId,
    username: username,
    signInDetails: CognitoSignInDetailsApiBased(username: username),
  );

  static const jwtString =
      // ignore: lines_longer_than_80_chars
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

  static final jwt = JsonWebToken.parse(jwtString);

  static final cognitoAuthSession = CognitoAuthSession(
    isSignedIn: true,
    userPoolTokensResult: AWSResult.success(
      CognitoUserPoolTokens(
        accessToken: TestHelpers.jwt,
        refreshToken: 'refreshToken',
        idToken: TestHelpers.jwt,
      ),
    ),
    userSubResult: const AWSResult.success('userSub'),
    credentialsResult: const AWSResult.success(
        AWSCredentials('accessKeyId', 'secretAccessKey')),
    identityIdResult: const AWSResult.success('identityId'),
  );
}
