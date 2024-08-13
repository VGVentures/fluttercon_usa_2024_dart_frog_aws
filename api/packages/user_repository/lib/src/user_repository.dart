import 'package:user_repository/user_repository.dart';

/// {@template user_repository}
/// A class managing user authentication.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required AmplifyAuthClient authClient,
    User? currentUser,
  })  : _authClient = authClient,
        _currentUser = currentUser;

  final AmplifyAuthClient _authClient;
  User? _currentUser;

  /// Get current user from session.
  Future<User?> getCurrentUser() async {
    try {
      if (_currentUser != null) {
        return _currentUser;
      }

      final currentSession = await _authClient.getCurrentSession();
      final token = currentSession.credentialsResult.value.sessionToken;
      if (token == null || token.isEmpty) {
        throw const AmplifyAuthException(
          exception: 'Session token is empty',
        );
      }

      return _currentUser ??= User(
        id: currentSession.identityIdResult.value,
        sessionToken: token,
      );
    } on Exception catch (e) {
      throw AmplifyAuthException(exception: e);
    }
  }

  /// Verify that current user matches session token.
  Future<User?> verifyUserFromToken(String token) async {
    try {
      final user = _currentUser ?? await getCurrentUser();

      if (user?.sessionToken == token) {
        return user;
      } else {
        throw const AmplifyAuthException(
          exception: 'Token does not match current user',
        );
      }
    } on Exception catch (e) {
      throw AmplifyAuthException(exception: e);
    }
  }
}
