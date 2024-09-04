import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:hive/hive.dart';

class FlutterconHiveCache extends FlutterconCache {
  FlutterconHiveCache(this._box);

  final Box _box;

  @override
  Future<void> clear() async {
    if (!_box.isOpen) {
      await Hive.openBox('fluttercon_cache');
    }
    await _box.clear();
  }

  @override
  Future<String?> get(String key) async {
    if (!_box.isOpen) {
      await Hive.openBox('fluttercon_cache');
    }
    return _box.get(key) as String?;
  }

  @override
  Future<void> set(String key, String value) async {
    if (!_box.isOpen) {
      await Hive.openBox('fluttercon_cache');
    }
    await _box.put(key, value);
  }
}
