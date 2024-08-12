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
  Future<AuthUser?> getCurrentUser() => _auth.getCurrentUser();
}
