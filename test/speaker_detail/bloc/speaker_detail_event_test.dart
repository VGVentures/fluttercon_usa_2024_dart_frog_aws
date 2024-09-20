// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';

void main() {
  group('SpeakerDetailEvent', () {
    group('SpeakerDetailRequested', () {
      test('supports value equality', () {
        expect(
          SpeakerDetailRequested(id: 'id'),
          equals(
            SpeakerDetailRequested(id: 'id'),
          ),
        );
      });
    });

    group('FavoriteToggleRequested', () {
      test('supports value equality', () {
        expect(
          FavoriteToggleRequested(
            userId: 'userId',
            talkId: '1',
            isFavorite: false,
          ),
          equals(
            FavoriteToggleRequested(
              userId: 'userId',
              talkId: '1',
              isFavorite: false,
            ),
          ),
        );
      });
    });
  });
}
