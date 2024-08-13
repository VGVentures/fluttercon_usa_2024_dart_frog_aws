/// {@template user}
/// Data model representing a user.
/// {@endtemplate}
class User {
  /// {@macro user}
  User({
    required this.id,
    required this.sessionToken,
  });

  /// Unique identifier for the user.
  final String id;

  /// Valid session token for the user.
  final String sessionToken;
}
