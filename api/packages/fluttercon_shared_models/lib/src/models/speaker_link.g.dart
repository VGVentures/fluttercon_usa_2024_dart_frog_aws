// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeakerLink _$SpeakerLinkFromJson(Map<String, dynamic> json) => SpeakerLink(
      id: json['id'] as String,
      url: json['url'] as String,
      type: $enumDecode(_$SpeakerLinkTypeEnumMap, json['type']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SpeakerLinkToJson(SpeakerLink instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'type': _$SpeakerLinkTypeEnumMap[instance.type]!,
      'description': instance.description,
    };

const _$SpeakerLinkTypeEnumMap = {
  SpeakerLinkType.github: 'github',
  SpeakerLinkType.linkedIn: 'linkedIn',
  SpeakerLinkType.twitter: 'twitter',
  SpeakerLinkType.other: 'other',
};
