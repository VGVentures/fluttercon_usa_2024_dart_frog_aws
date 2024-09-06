// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_favorite_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFavoriteRequest _$CreateFavoriteRequestFromJson(
        Map<String, dynamic> json) =>
    CreateFavoriteRequest(
      userId: json['userId'] as String,
      talkId: json['talkId'] as String,
    );

Map<String, dynamic> _$CreateFavoriteRequestToJson(
        CreateFavoriteRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'talkId': instance.talkId,
    };
