import 'package:amplify_core/amplify_core.dart';
import 'package:user_repository/user_repository.dart';

/// {@template user_repository}
/// A class managing user authentication.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({required AmplifyAuthClient authClient})
      : _authClient = authClient;

  final AmplifyAuthClient _authClient;

  /// Get current user from session.
  Future<AuthUser?> getCurrentUser() async {
    try {
      return await _authClient.getCurrentUser();
    } on Exception catch (e) {
      throw AmplifyAuthException(exception: e);
    }
  }
}
