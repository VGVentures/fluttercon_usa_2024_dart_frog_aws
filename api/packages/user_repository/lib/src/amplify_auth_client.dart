import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:amplify_core/amplify_core.dart';

/// {@template amplify_auth_client}
/// Wrapper around Amplify Auth.
/// {@endtemplate}
class AmplifyAuthClient {
  /// {@macro amplify_auth_client}
  AmplifyAuthClient({
    required AuthCategory auth,
  }) : _auth = auth;

  final AuthCategory _auth;

  /// Get current user.
  Future<AuthUser?> getCurrentUser() async => _auth.getCurrentUser();

  /// Get the current session token.
  Future<String?> getSessionToken() async {
    final cognitoPlugin = _auth.getPlugin(AmplifyAuthCognitoDart.pluginKey);
    final session = await cognitoPlugin.fetchAuthSession();
    final credentials = session.credentialsResult.value;
    return credentials.sessionToken;
  }
}
