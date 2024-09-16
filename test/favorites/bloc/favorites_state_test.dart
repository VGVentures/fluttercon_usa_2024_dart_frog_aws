// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/favorites/favorites.dart';

import '../../helpers/test_data.dart';

void main() {
  group('FavoritesState', () {
    group('FavoritesInitial', () {
      test('supports value equality', () {
        expect(FavoritesInitial(), equals(FavoritesInitial()));
      });
    });

    group('FavoritesLoading', () {
      test('supports value equality', () {
        expect(FavoritesLoading(), equals(FavoritesLoading()));
      });
    });

    group('FavoritesLoaded', () {
      test('supports value equality', () {
        expect(
          FavoritesLoaded(
            talks: TestData.talkTimeSlotData(favorites: true).items,
            favoriteIds: TestData.favoriteIds,
          ),
          equals(
            FavoritesLoaded(
              talks: TestData.talkTimeSlotData(favorites: true).items,
              favoriteIds: TestData.favoriteIds,
            ),
          ),
        );
      });

      group('copyWith', () {
        test('returns same object when no properties are passed', () {
          final loaded = FavoritesLoaded(
            talks: TestData.talkTimeSlotData(favorites: true).items,
            favoriteIds: TestData.favoriteIds,
          );
          expect(loaded.copyWith(), equals(loaded));
        });

        test('returns object with updated properties', () {
          final loaded = FavoritesLoaded(
            talks: TestData.talkTimeSlotData(favorites: true).items,
            favoriteIds: TestData.favoriteIds,
          );
          expect(
            loaded.copyWith(favoriteIds: ['2', '3']),
            equals(
              FavoritesLoaded(
                talks: TestData.talkTimeSlotData(favorites: true).items,
                favoriteIds: const ['2', '3'],
              ),
            ),
          );
        });
      });
    });

    group('FavoritesError', () {
      test('supports value equality', () {
        expect(
          FavoritesError(error: TestData.error),
          equals(FavoritesError(error: TestData.error)),
        );
      });
    });
  });
}
