import 'package:fluttercon_cache/fluttercon_cache.dart';

/// {@template fluttercon_in_memory_cache}
/// A simple in-memory implementation of a cache.
/// {@endtemplate}
class FlutterconInMemoryCache extends FlutterconCache {
  final _cache = <String, dynamic>{};

  @override
  Future<dynamic> get(String key) async {
    return _cache[key];
  }

  @override
  Future<void> set(String key, dynamic value) async {
    _cache[key] = value;
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }
}
