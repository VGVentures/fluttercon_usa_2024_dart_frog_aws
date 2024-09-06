import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_favorite_response.g.dart';

/// {@template create_favorite_response}
/// A data model representing a response to create a favorite talk.
/// {@endtemplate}
@JsonSerializable()
class CreateFavoriteResponse extends Equatable {
  /// {@macro create_favorite_response}
  const CreateFavoriteResponse({
    required this.userId,
    required this.talkId,
  });

  /// Converts a JSON object into a [CreateFavoriteResponse] instance.
  factory CreateFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteResponseFromJson(json);

  /// Converts this [CreateFavoriteResponse] instance into a JSON object.
  Map<String, dynamic> toJson() => _$CreateFavoriteResponseToJson(this);

  /// The unique ID corresponding to the user who is adding the favorite talk.
  final String userId;

  /// The unique ID corresponding to the talk being added to favorites.
  final String talkId;

  @override
  List<Object?> get props => [userId, talkId];
}
