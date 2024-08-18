import 'package:equatable/equatable.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'talk_detail.g.dart';

/// {@template talk_detail}
/// A data model containing detailed information about a Talk.
/// {@endtemplate}
@JsonSerializable()
class TalkDetail extends Equatable {
  /// {@macro talk_detail}
  const TalkDetail({
    required this.id,
    required this.title,
    required this.room,
    required this.startTime,
    required this.speakers,
    required this.description,
  });

  /// Converts a JSON object into a [TalkDetail] instance.
  factory TalkDetail.fromJson(Map<String, dynamic> json) =>
      _$TalkDetailFromJson(json);

  /// Converts this [TalkDetail] instance into a JSON object.
  Map<String, dynamic> toJson() => _$TalkDetailToJson(this);

  /// The time that the talk is scheduled to start.
  final DateTime startTime;

  /// Summary information for the speaker(s) presenting the talk.
  final List<SpeakerPreview> speakers;

  /// A short description of the talk.
  final String description;

  /// The unique identifier for this talk.
  final String id;

  /// The room where the talk is being held.
  final String room;

  /// The title of the talk.
  final String title;

  @override
  List<Object?> get props => [
        id,
        title,
        room,
        startTime,
        speakers,
        description,
      ];
}
