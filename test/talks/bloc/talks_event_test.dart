// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';

void main() {
  group('TalksEvent', () {
    group('TalksRequested', () {
      test('supports value equality', () {
        expect(TalksRequested(), equals(TalksRequested()));
      });
    });
  });
}
