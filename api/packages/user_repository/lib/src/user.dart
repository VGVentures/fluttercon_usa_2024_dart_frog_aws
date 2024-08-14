import 'package:equatable/equatable.dart';

/// {@template user}
/// Data model representing a user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
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

  @override
  List<Object?> get props => [id, sessionToken];
}
