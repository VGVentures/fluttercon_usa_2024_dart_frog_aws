import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:test/test.dart';

void main() {
  group('tryGetFromCache', () {
    const cacheData = {'data': 'value'};
    const orElseData = {'data': 'orElse value'};
    test('returns from cache if found', () async {
      final result = await tryGetFromCache(
        getFromCache: () async => jsonEncode(cacheData),
        fromJson: (json) => json,
        orElse: () async => orElseData,
      );

      expect(result, equals(cacheData));
    });

    test('calls orElse if cache returns null', () async {
      final result = await tryGetFromCache(
        getFromCache: () async => null,
        fromJson: (json) => json,
        orElse: () async => orElseData,
      );
      expect(result, equals(orElseData));
    });
  });
}
