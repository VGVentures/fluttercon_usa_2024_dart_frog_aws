// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/favorites/favorites.dart';

void main() {
  group('FavoritesEvent', () {
    group('FavoritesRequested', () {
      test('supports value equality', () {
        expect(FavoritesRequested(), equals(FavoritesRequested()));
      });
    });

    group('RemoveFavoriteRequested', () {
      test('supports value equality', () {
        expect(
          RemoveFavoriteRequested(
            userId: 'userId',
            talkId: '1',
          ),
          equals(
            RemoveFavoriteRequested(
              userId: 'userId',
              talkId: '1',
            ),
          ),
        );
      });
    });
  });
}
