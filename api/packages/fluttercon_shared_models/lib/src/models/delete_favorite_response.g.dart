// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_favorite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteFavoriteResponse _$DeleteFavoriteResponseFromJson(
        Map<String, dynamic> json) =>
    DeleteFavoriteResponse(
      userId: json['userId'] as String,
      talkId: json['talkId'] as String,
    );

Map<String, dynamic> _$DeleteFavoriteResponseToJson(
        DeleteFavoriteResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'talkId': instance.talkId,
    };
