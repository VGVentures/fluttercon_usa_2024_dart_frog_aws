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
        _currentUser = currentUser,
        _sessionToken = currentUser?.sessionToken;

  final AmplifyAuthClient _authClient;
  User? _currentUser;
  String? _sessionToken;

  /// Get current user from session.
  Future<User?> getCurrentUser() async {
    try {
      if (_currentUser != null) {
        return _currentUser;
      }

      final amplifyUser = await _authClient.getCurrentUser();
      if (amplifyUser == null) {
        return null;
      }

      _sessionToken ??= await _authClient.getSessionToken();
      if (_sessionToken == null || _sessionToken!.isEmpty) {
        throw const AmplifyAuthException(
          exception: 'Session token is empty',
        );
      }

      return _currentUser ??= User(
        id: amplifyUser.userId,
        sessionToken: _sessionToken!,
      );
    } on Exception catch (e) {
      throw AmplifyAuthException(exception: e);
    }
  }

  /// Verify that current user matches session token.
  Future<User?> verifyUserFromToken(String token) async {
    try {
      final user = _currentUser ?? await getCurrentUser();
      final currentToken = _sessionToken ?? await _authClient.getSessionToken();
      if (currentToken == token) {
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
