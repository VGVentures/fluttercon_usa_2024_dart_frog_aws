// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedData<T> _$PaginatedDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedData<T>(
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
      limit: (json['limit'] as num?)?.toInt(),
      nextToken: json['nextToken'] as String?,
    );

Map<String, dynamic> _$PaginatedDataToJson<T>(
  PaginatedData<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'items': instance.items.map(toJsonT).toList(),
      'limit': instance.limit,
      'nextToken': instance.nextToken,
    };
