// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkDetail _$TalkDetailFromJson(Map<String, dynamic> json) => TalkDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      room: json['room'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      speakers: (json['speakers'] as List<dynamic>)
          .map((e) => SpeakerPreview.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$TalkDetailToJson(TalkDetail instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'speakers': instance.speakers.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'id': instance.id,
      'room': instance.room,
      'title': instance.title,
    };
