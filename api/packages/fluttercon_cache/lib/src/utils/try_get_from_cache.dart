import 'dart:convert';

/// Attempts to fetch a value from the cache.
/// If not present, the cache will call the method
/// in [orElse] to fetch the data.
/// [fromJson] is necessary to deserialize the value.
Future<T> tryGetFromCache<T>({
  required Future<String?> Function() getFromCache,
  required T Function(Map<String, dynamic>) fromJson,
  required Future<T> Function() orElse,
}) async {
  final cached = await getFromCache();
  if (cached != null) {
    return fromJson(jsonDecode(cached) as Map<String, dynamic>);
  }
  return orElse();
}
