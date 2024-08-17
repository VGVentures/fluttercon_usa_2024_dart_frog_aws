import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'speaker_link.g.dart';

/// Common types of links that a speaker might have.
enum SpeakerLinkType {
  /// A link to the speaker's Github profile.
  github,

  /// A link to the speaker's LinkedIn profile.
  linkedIn,

  /// A link to the speaker's Twitter profile.
  twitter,

  /// An other link provided, such as a personal or company website.
  other,
}

/// {@template speaker_link}
/// A link to a speaker's social media profile or other website.
/// {@endtemplate}
@JsonSerializable()
class SpeakerLink extends Equatable {
  /// {@macro speaker_link}
  const SpeakerLink({
    required this.id,
    required this.url,
    required this.type,
    this.description,
  });

  /// Converts a JSON object into a [SpeakerLink] instance.
  factory SpeakerLink.fromJson(Map<String, dynamic> json) =>
      _$SpeakerLinkFromJson(json);

  /// Converts this [SpeakerLink] instance into a JSON object.
  Map<String, dynamic> toJson() => _$SpeakerLinkToJson(this);

  /// The unique identifier for this link.
  final String id;

  /// The actual URL value of the link.
  final String url;

  /// The type of link that this is.
  final SpeakerLinkType type;

  /// A description of where the link leads. Optional, used when
  /// the [type] is [SpeakerLinkType.other].
  final String? description;

  @override
  List<Object?> get props => [id, url, type, description];
}
