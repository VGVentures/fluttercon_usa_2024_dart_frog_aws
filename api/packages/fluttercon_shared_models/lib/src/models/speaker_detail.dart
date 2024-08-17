import 'package:equatable/equatable.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_shared_models/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'speaker_detail.g.dart';

/// {@template speaker_detail}
/// A data model containing detailed information about a Speaker.
/// {@endtemplate}
@JsonSerializable()
class SpeakerDetail extends Equatable {
  /// {@macro speaker_detail}
  const SpeakerDetail({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.bio,
    required this.links,
    required this.talks,
  });

  /// Converts a JSON object into a [SpeakerDetail] instance.
  factory SpeakerDetail.fromJson(Map<String, dynamic> json) =>
      _$SpeakerDetailFromJson(json);

  /// Converts this [SpeakerDetail] instance into a JSON object.
  Map<String, dynamic> toJson() => _$SpeakerDetailToJson(this);

  /// The unique identifier for this speaker.
  final String id;

  /// The name of the speaker.
  final String name;

  /// The title of the speaker, presented with the talk.
  final String title;

  /// The URL to the speaker's image.
  final String imageUrl;

  /// A short biography of the speaker.
  final String bio;

  /// A list of links to the speaker's social media profiles and other websites.
  final List<SpeakerLink> links;

  /// A list of talks that the speaker is presenting.
  final List<TalkPreview> talks;

  @override
  List<Object?> get props => [id, name, title, imageUrl, bio, links, talks];
}
