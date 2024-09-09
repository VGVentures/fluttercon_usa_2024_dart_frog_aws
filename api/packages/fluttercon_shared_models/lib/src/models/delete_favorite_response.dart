import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_favorite_response.g.dart';

/// {@template delete_favorite_response}
/// A data model representing a response to delete a favorite talk.
/// {@endtemplate}
@JsonSerializable()
class DeleteFavoriteResponse extends Equatable {
  /// {@macro delete_favorite_response}
  const DeleteFavoriteResponse({
    required this.userId,
    required this.talkId,
  });

  /// Converts a JSON object into a [DeleteFavoriteResponse] instance.
  factory DeleteFavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteFavoriteResponseFromJson(json);

  /// Converts this [DeleteFavoriteResponse] instance into a JSON object.
  Map<String, dynamic> toJson() => _$DeleteFavoriteResponseToJson(this);

  /// The unique ID corresponding to the user who is adding the favorite talk.
  final String userId;

  /// The unique ID corresponding to the talk being added to favorites.
  final String talkId;

  @override
  List<Object?> get props => [userId, talkId];
}
