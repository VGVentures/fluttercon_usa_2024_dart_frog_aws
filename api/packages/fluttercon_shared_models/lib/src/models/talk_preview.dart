import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'talk_preview.g.dart';

/// {@template talk_preview}
/// A data model containing a summary of talk information.
/// {@endtemplate}
@JsonSerializable()
class TalkPreview extends Equatable {
  /// {@macro talk_preview}
  const TalkPreview({
    required this.id,
    required this.title,
    required this.room,
    required this.startTime,
    required this.speakerNames,
    required this.isFavorite,
  });

  /// Converts a JSON object into a [TalkPreview] instance.
  factory TalkPreview.fromJson(Map<String, dynamic> json) =>
      _$TalkPreviewFromJson(json);

  /// Converts this [TalkPreview] instance into a JSON object.
  Map<String, dynamic> toJson() => _$TalkPreviewToJson(this);

  /// The unique identifier for this talk.
  final String id;

  /// The title of the talk.
  final String title;

  /// The room where the talk is being held.
  final String room;

  /// The time that the talk is scheduled to start.
  final DateTime startTime;

  /// The name(s) of the speaker(s) presenting the talk.
  final List<String> speakerNames;

  /// Whether the talk is one of the current user's favorites.
  final bool isFavorite;

  @override
  List<Object?> get props => [
        id,
        title,
        room,
        startTime,
        speakerNames,
        isFavorite,
      ];
}
