import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_favorite_request.g.dart';

/// {@template delete_favorite_request}
/// A data model representing a request to delete a favorite talk.
/// {@endtemplate}
@JsonSerializable()
class DeleteFavoriteRequest extends Equatable {
  /// {@macro delete_favorite_request}
  const DeleteFavoriteRequest({
    required this.userId,
    required this.talkId,
  });

  /// Converts a JSON object into a [DeleteFavoriteRequest] instance.
  factory DeleteFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteFavoriteRequestFromJson(json);

  /// Converts this [DeleteFavoriteRequest] instance into a JSON object.
  Map<String, dynamic> toJson() => _$DeleteFavoriteRequestToJson(this);

  /// The unique ID corresponding to the user who is adding the favorite talk.
  final String userId;

  /// The unique ID corresponding to the talk being added to favorites.
  final String talkId;

  @override
  List<Object?> get props => [userId, talkId];
}
