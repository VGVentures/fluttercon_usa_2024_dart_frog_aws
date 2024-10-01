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
  });
}
