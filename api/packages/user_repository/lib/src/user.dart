/// {@template user}
/// Data model representing a user.
/// {@endtemplate}
class User {
  /// {@macro user}
  User({
    required this.id,
    required this.sessionToken,
  });

  /// Deserialize the user model from json.
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        sessionToken: json['sessionToken'] as String,
      );

  /// Serialize the user model to json.
  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionToken': sessionToken,
      };

  /// Unique identifier for the user.
  final String id;

  /// Valid session token for the user.
  final String sessionToken;

  /// Serialize the user model to json.
}
