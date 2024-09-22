import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterconCache', () {
    late FlutterconInMemoryCache cache;

    setUp(() {
      cache = FlutterconInMemoryCache();
    });

    tearDown(() {
      cache.clear();
    });

    group('getOrElse', () {
      const cacheData = {'data': 'value'};
      const orElseData = {'data': 'orElse value'};
      test('returns the value if the key is found', () async {
        await cache.set('key', jsonEncode(cacheData));
        final value = await cache.getOrElse(
          key: 'key',
          fromJson: (json) => json,
          orElse: () async => orElseData,
        );
        expect(value, equals(cacheData));
      });

      test('calls orElse if the key is not found', () async {
        final value = await cache.getOrElse(
          key: 'key',
          fromJson: (json) => json,
          orElse: () async => orElseData,
        );
        expect(value, equals(orElseData));
      });
    });
  });
}
