import 'package:amplify_core/amplify_core.dart';

/// Deserializes a JSON body to [PaginatedResult].
PaginatedResult<T> paginatedResultFromJson<T extends Model>(
  Map<String, dynamic> json,
  ModelType<T> modelType,
) {
  final items = (json['items'] as List<dynamic>)
      .map((item) => modelType.fromJson(item as Map<String, dynamic>))
      .toList();
  final nextToken = json['nextToken'] as String?;
  return PaginatedResult<T>(
    items,
    null,
    nextToken,
    null,
    modelType,
    null,
  );
}
