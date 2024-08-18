import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'speaker_preview.g.dart';

/// {@template speaker_preview}
/// A data model representing a summary of speaker information.
/// {@endtemplate}
@JsonSerializable()
class SpeakerPreview extends Equatable {
  /// {@macro speaker_preview}
  const SpeakerPreview({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
  });

  /// Converts a JSON object into a [SpeakerPreview] instance.
  factory SpeakerPreview.fromJson(Map<String, dynamic> json) =>
      _$SpeakerPreviewFromJson(json);

  /// Converts this [SpeakerPreview] instance into a JSON object.
  Map<String, dynamic> toJson() => _$SpeakerPreviewToJson(this);

  /// The unique identifier for this speaker.
  final String id;

  /// The name of the speaker.
  final String name;

  /// The title of the speaker, presented with the talk.
  final String title;

  /// The URL to the speaker's image.
  final String imageUrl;

  @override
  List<Object?> get props => [id, name, title, imageUrl];
}
