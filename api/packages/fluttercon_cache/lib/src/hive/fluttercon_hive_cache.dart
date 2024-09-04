import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:hive/hive.dart';

/// {@template fluttercon_hive_cache}
/// A [FlutterconCache] implementation that uses HiveDb for caching.
/// {@endtemplate}
class FlutterconHiveCache extends FlutterconCache {
  /// {@macro fluttercon_hive_cache}
  FlutterconHiveCache({required Box<String> box}) : _box = box;

  final Box<String> _box;

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<String?> get(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> set(String key, String value) async {
    await _box.put(key, value);
  }
}
