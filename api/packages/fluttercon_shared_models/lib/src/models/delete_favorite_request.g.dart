// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_favorite_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteFavoriteRequest _$DeleteFavoriteRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteFavoriteRequest(
      userId: json['userId'] as String,
      talkId: json['talkId'] as String,
    );

Map<String, dynamic> _$DeleteFavoriteRequestToJson(
        DeleteFavoriteRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'talkId': instance.talkId,
    };
