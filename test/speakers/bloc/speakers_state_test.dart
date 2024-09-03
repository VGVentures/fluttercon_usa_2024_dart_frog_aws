// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/speakers/speakers.dart';

import '../../helpers/test_data.dart';

void main() {
  group('SpeakersState', () {
    group('SpeakersInitial', () {
      test('supports value equality', () {
        expect(SpeakersInitial(), equals(SpeakersInitial()));
      });
    });

    group('SpeakersLoading', () {
      test('supports value equality', () {
        expect(SpeakersLoading(), equals(SpeakersLoading()));
      });
    });

    group('SpeakersLoaded', () {
      test('supports value equality', () {
        expect(
          SpeakersLoaded(speakers: TestData.speakerData.items),
          equals(SpeakersLoaded(speakers: TestData.speakerData.items)),
        );
      });
    });

    group('SpeakersError', () {
      test('supports value equality', () {
        expect(
          SpeakersError(error: TestData.error),
          equals(SpeakersError(error: TestData.error)),
        );
      });
    });
  });
}
