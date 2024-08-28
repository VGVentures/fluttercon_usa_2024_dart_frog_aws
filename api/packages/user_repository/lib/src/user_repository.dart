import 'package:user_repository/user_repository.dart';

/// {@template user_repository}
/// A class managing user authentication.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required AmplifyAuthClient authClient,
  }) : _authClient = authClient;

  final AmplifyAuthClient _authClient;

  /// Get current user from Cognito auth session.
  Future<User?> getCurrentUser() async {
    try {
      final currentSession = await _authClient.fetchAuthSession();
      final token = currentSession.credentialsResult.value.sessionToken;
      if (token == null || token.isEmpty) {
        return null;
      }

      return User(
        id: currentSession.identityIdResult.value,
        sessionToken: token,
      );
    } on Exception {
      return null;
    }
  }

  /// Verify that current user matches session token.
  Future<User?> verifyUserFromToken(String token) async {
    final user = await getCurrentUser();

    // Disabled for use with anonymous auth on the demo app.
    // A real production app would add logic similar to this
    // to verify that the session token passed from the client
    // matches a valid token for a user persisted in a user pool.
    // return user?.sessionToken == token ? user : null;

    return user;
  }
}
