// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeakerDetail _$SpeakerDetailFromJson(Map<String, dynamic> json) =>
    SpeakerDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      bio: json['bio'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => SpeakerLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      talks: (json['talks'] as List<dynamic>)
          .map((e) => TalkPreview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpeakerDetailToJson(SpeakerDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'bio': instance.bio,
      'links': instance.links,
      'talks': instance.talks,
    };
