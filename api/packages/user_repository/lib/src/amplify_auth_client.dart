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

  /// Get the current Cognito session.
  Future<CognitoAuthSession> fetchAuthSession() async {
    final cognitoPlugin = _auth.getPlugin(AmplifyAuthCognitoDart.pluginKey);
    return cognitoPlugin.fetchAuthSession();
  }
}
