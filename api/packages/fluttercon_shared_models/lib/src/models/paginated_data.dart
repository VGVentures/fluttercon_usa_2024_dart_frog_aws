import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_data.g.dart';

/// {@template paginated_data}
/// A data model containing a paginated list of items,
/// with properties to determine whether to fetch more data.
/// {@endtemplate}
@JsonSerializable(genericArgumentFactories: true)
class PaginatedData<T> extends Equatable {
  /// {@macro paginated_data}
  const PaginatedData({
    required this.items,
    this.limit,
    this.nextToken,
  });

  /// Converts a JSON object into a [PaginatedData] instance.
  factory PaginatedData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedDataFromJson(json, fromJsonT);

  /// Converts this [PaginatedData] instance into a JSON object.
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedDataToJson(this, toJsonT);

  /// The list of items fetched.
  final List<T> items;

  /// The maximum number of items to fetch.
  final int? limit;

  /// The token to use to fetch the next set of items.
  /// If null, no more data will be fetched.
  final String? nextToken;

  @override
  List<Object?> get props => [items, limit, nextToken];
}
