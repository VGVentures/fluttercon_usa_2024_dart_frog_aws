// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';

void main() {
  group('TalkDetailEvent', () {
    group('TalkDetailRequested', () {
      test('supports value equality', () {
        expect(
          TalkDetailRequested(id: 'id'),
          equals(TalkDetailRequested(id: 'id')),
        );
      });
    });
  });
}
