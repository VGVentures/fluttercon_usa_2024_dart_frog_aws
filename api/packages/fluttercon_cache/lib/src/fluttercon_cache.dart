import 'dart:convert';

/// {@template fluttercon_cache}
/// An abstract cache. Can be implemented with any cache provider.
/// {@endtemplate}
abstract class FlutterconCache {
  /// Fetches the value associated with [key].
  Future<String?> get(String key);

  /// Sets the [value] associated with [key].
  Future<void> set(String key, String value);

  /// Clears the cache.
  Future<void> clear();

  /// Attempts to fetch a value from the cache.
  /// If not present, the cache will call the method
  /// in [orElse] to fetch the data.
  /// [fromJson] is necessary to deserialize the value.
  Future<T> getOrElse<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    required Future<T> Function() orElse,
  }) async {
    final cached = await get(key);
    if (cached != null) {
      return fromJson(jsonDecode(cached) as Map<String, dynamic>);
    }
    return orElse();
  }
}
