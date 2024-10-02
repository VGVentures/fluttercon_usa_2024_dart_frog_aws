import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:test/test.dart';

void main() {
  group('speakerCacheKey', () {
    test('returns the correct cache key', () {
      expect(speakerCacheKey('123'), equals('speaker_123'));
    });
  });

  group('speakerTalksCacheKey', () {
    test('returns the correct cache key', () {
      expect(speakerTalksCacheKey('1,2,3'), equals('speaker_talks_1,2,3'));
    });
  });

  group('favoritesCacheKey', () {
    test('returns the correct cache key', () {
      expect(favoritesCacheKey('123'), equals('favorites_123'));
    });
  });

  group('talkCacheKey', () {
    test('returns the correct cache key', () {
      expect(talkCacheKey('123'), equals('talk_123'));
    });
  });
}
