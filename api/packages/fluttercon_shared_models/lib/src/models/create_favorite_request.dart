import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_favorite_request.g.dart';

/// {@template create_favorite_request}
/// A data model representing a request to create a favorite talk.
/// {@endtemplate}
@JsonSerializable()
class CreateFavoriteRequest extends Equatable {
  /// {@macro create_favorite_request}
  const CreateFavoriteRequest({
    required this.userId,
    required this.talkId,
  });

  /// Converts a JSON object into a [CreateFavoriteRequest] instance.
  factory CreateFavoriteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFavoriteRequestFromJson(json);

  /// Converts this [CreateFavoriteRequest] instance into a JSON object.
  Map<String, dynamic> toJson() => _$CreateFavoriteRequestToJson(this);

  /// The unique ID corresponding to the user who is adding the favorite talk.
  final String userId;

  /// The unique ID corresponding to the talk being added to favorites.
  final String talkId;

  @override
  List<Object?> get props => [userId, talkId];
}
