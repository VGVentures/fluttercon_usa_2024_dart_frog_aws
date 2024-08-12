import 'dart:math';

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

  /// Get current user from session.
  Future<AuthUser?> getCurrentUser() async {
    final stuff = await _auth.fetchUserAttributes();
    final things = stuff.where((element) => element.userAttributeKey == 'sub');

    final cognitoPlugin =
        Amplify.Auth.getPlugin(AmplifyAuthCognitoDart.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final creds = result.credentialsResult.value;
    final token = creds.sessionToken;
    final identityId = result.identityIdResult.value;
    result.credentialsResult.value;

    return _auth.getCurrentUser(
      options: const GetCurrentUserOptions(
        pluginOptions: CognitoGetCurrentUserPluginOptions(),
      ),
    );
  }
}
