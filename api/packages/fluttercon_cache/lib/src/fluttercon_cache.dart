/// {@template fluttercon_cache}
/// An abstract cache. Can be implemented with any cache provider.
/// {@endtemplate}
abstract class FlutterconCache {
  /// Fetches the value associated with [key].
  Future<dynamic> get(String key);

  /// Sets the [value] associated with [key].
  Future<void> set(String key, dynamic value);

  /// Clears the cache.
  Future<void> clear();
}
