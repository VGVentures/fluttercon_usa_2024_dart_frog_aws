// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkPreview _$TalkPreviewFromJson(Map<String, dynamic> json) => TalkPreview(
      id: json['id'] as String,
      title: json['title'] as String,
      room: json['room'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      speakerNames: (json['speakerNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isFavorite: json['isFavorite'] as bool,
    );

Map<String, dynamic> _$TalkPreviewToJson(TalkPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'room': instance.room,
      'startTime': instance.startTime.toIso8601String(),
      'speakerNames': instance.speakerNames,
      'isFavorite': instance.isFavorite,
    };
