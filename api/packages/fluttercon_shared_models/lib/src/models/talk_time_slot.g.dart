// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_time_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkTimeSlot _$TalkTimeSlotFromJson(Map<String, dynamic> json) => TalkTimeSlot(
      startTime: DateTime.parse(json['startTime'] as String),
      talks: (json['talks'] as List<dynamic>)
          .map((e) => TalkPreview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TalkTimeSlotToJson(TalkTimeSlot instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'talks': instance.talks.map((e) => e.toJson()).toList(),
    };
