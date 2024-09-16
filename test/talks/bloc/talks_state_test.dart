// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';

import '../../helpers/test_data.dart';

void main() {
  group('TalksState', () {
    group('TalksInitial', () {
      test('supports value equality', () {
        expect(TalksInitial(), equals(TalksInitial()));
      });
    });

    group('TalksLoading', () {
      test('supports value equality', () {
        expect(TalksLoading(), equals(TalksLoading()));
      });
    });

    group('TalksLoaded', () {
      test('supports value equality', () {
        expect(
          TalksLoaded(talkTimeSlots: TestData.talkTimeSlotData().items),
          equals(TalksLoaded(talkTimeSlots: TestData.talkTimeSlotData().items)),
        );
      });

      group('copyWith', () {
        test('returns same object when no properties are passed', () {
          final loaded =
              TalksLoaded(talkTimeSlots: TestData.talkTimeSlotData().items);
          expect(loaded.copyWith(), equals(loaded));
        });

        test('returns object with updated properties', () {
          final loaded =
              TalksLoaded(talkTimeSlots: TestData.talkTimeSlotData().items);
          expect(
            loaded.copyWith(favoriteIds: ['1']),
            equals(
              TalksLoaded(
                talkTimeSlots: TestData.talkTimeSlotData().items,
                favoriteIds: const ['1'],
              ),
            ),
          );
        });
      });
    });

    group('TalksError', () {
      test('supports value equality', () {
        expect(
          TalksError(error: TestData.error),
          equals(TalksError(error: TestData.error)),
        );
      });
    });
  });
}
