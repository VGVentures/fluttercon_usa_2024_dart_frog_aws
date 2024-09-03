// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/speakers/speakers.dart';

void main() {
  group('SpeakersEvent', () {
    group('SpeakersRequested', () {
      test('supports value equality', () {
        expect(SpeakersRequested(), equals(SpeakersRequested()));
      });
    });
  });
}
