import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockBox extends Mock implements Box<String> {}

void main() {
  group('FlutterconHiveCache', () {
    late Box<String> box;
    late FlutterconHiveCache cache;

    setUp(() {
      box = _MockBox();
      cache = FlutterconHiveCache(box: box);
      when(() => box.clear()).thenAnswer((_) async => 0);
    });

    tearDown(() {
      cache.clear();
    });

    test('can be instantiated', () {
      expect(cache, isNotNull);
    });

    test('returns null if the key is not found', () async {
      when(() => box.get('key')).thenReturn(null);
      final value = await cache.get('key');
      expect(value, isNull);
    });

    test('returns the value if the key is found', () async {
      when(() => box.get('key')).thenReturn('value');
      final value = await cache.get('key');
      expect(value, equals('value'));
    });

    test('sets the value', () async {
      when(() => box.put('key', 'value')).thenAnswer((_) async => 0);
      await cache.set('key', 'value');
      verify(() => box.put('key', 'value')).called(1);
    });

    test('clears the cache', () async {
      await cache.clear();
      verify(() => box.clear()).called(1);
    });
  });
}
