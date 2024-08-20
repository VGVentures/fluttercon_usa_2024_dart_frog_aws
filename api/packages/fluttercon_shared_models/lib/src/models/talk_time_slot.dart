import 'package:equatable/equatable.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'talk_time_slot.g.dart';

/// {@template talk_time_slot}
/// A data model to sort multiple talks with the same scheduled
/// start time.
/// {@endtemplate}
@JsonSerializable()
class TalkTimeSlot extends Equatable {
  /// {@macro talk_time_slot}
  const TalkTimeSlot({
    required this.startTime,
    required this.talks,
  });

  /// Converts a [Map] to an instance of [TalkTimeSlot].
  factory TalkTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TalkTimeSlotFromJson(json);

  /// Converts this instance of [TalkTimeSlot] to a [Map].
  Map<String, dynamic> toJson() => _$TalkTimeSlotToJson(this);

  /// The scheduled start time for this time slot.
  final DateTime startTime;

  /// A list of talks scheduled to start at [startTime].
  final List<TalkPreview> talks;

  @override
  List<Object?> get props => [startTime, talks];
}
