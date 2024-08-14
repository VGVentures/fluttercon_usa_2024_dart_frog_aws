import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:user_repository/user_repository.dart';

class TestHelpers {
  static const userId = 'userId';
  static const sessionToken = 'sessionToken';

  static const user = User(
    id: userId,
    sessionToken: sessionToken,
  );

  static final userJson = {
    'id': TestHelpers.userId,
    'sessionToken': TestHelpers.sessionToken,
  };

  static const jwtString =
      // ignore: lines_longer_than_80_chars
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

  static final jwt = JsonWebToken.parse(jwtString);

  static CognitoAuthSession cognitoAuthSession({String? token = sessionToken}) {
    return CognitoAuthSession(
      isSignedIn: true,
      userPoolTokensResult: AWSResult.success(
        CognitoUserPoolTokens(
          accessToken: TestHelpers.jwt,
          refreshToken: 'refreshToken',
          idToken: TestHelpers.jwt,
        ),
      ),
      userSubResult: const AWSResult.success('userSub'),
      credentialsResult: AWSResult.success(
        AWSCredentials('accessKeyId', 'secretAccessKey', token),
      ),
      identityIdResult: const AWSResult.success(userId),
    );
  }
}
