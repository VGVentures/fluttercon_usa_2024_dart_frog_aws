// ignore_for_file: prefer_const_constructors
import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterconInMemoryCache', () {
    late FlutterconInMemoryCache cache;

    setUp(() {
      cache = FlutterconInMemoryCache();
    });

    tearDown(() {
      cache.clear();
    });

    test('can be instantiated', () {
      expect(cache, isNotNull);
    });

    test('returns null if the key is not found', () async {
      final value = await cache.get('key');
      expect(value, isNull);
    });

    test('returns the value if the key is found', () async {
      await cache.set('key', 'value');
      final value = await cache.get('key');
      expect(value, equals('value'));
    });

    test('clears the cache', () async {
      await cache.set('key', 'value');
      await cache.clear();
      final value = await cache.get('key');
      expect(value, isNull);
    });
  });
}
