// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';

import '../../helpers/test_data.dart';

void main() {
  group('SpeakerDetailState', () {
    group('SpeakerDetailInitial', () {
      test('supports value equality', () {
        expect(SpeakerDetailInitial(), equals(SpeakerDetailInitial()));
      });
    });

    group('SpeakerDetailLoading', () {
      test('supports value equality', () {
        expect(SpeakerDetailLoading(), equals(SpeakerDetailLoading()));
      });
    });

    group('SpeakerDetailLoaded', () {
      test('supports value equality', () {
        expect(
          SpeakerDetailLoaded(speaker: TestData.speakerDetail),
          equals(SpeakerDetailLoaded(speaker: TestData.speakerDetail)),
        );
      });

      group('copyWith', () {
        test('returns same object when no properties are passed', () {
          final loaded = SpeakerDetailLoaded(speaker: TestData.speakerDetail);
          expect(loaded.copyWith(), equals(loaded));
        });

        test('returns object with updated properties', () {
          final loaded = SpeakerDetailLoaded(speaker: TestData.speakerDetail);
          final newSpeaker = SpeakerDetail(
            id: 'id',
            title: 'title',
            name: 'name',
            bio: 'bio',
            imageUrl: 'imageUrl',
            links: const [],
            talks: const [],
          );

          expect(
            loaded.copyWith(speaker: newSpeaker),
            equals(
              SpeakerDetailLoaded(
                speaker: newSpeaker,
              ),
            ),
          );
        });
      });
    });

    group('SpeakerDetailError', () {
      test('supports value equality', () {
        expect(
          SpeakerDetailError(error: TestData.error),
          equals(SpeakerDetailError(error: TestData.error)),
        );
      });
    });
  });
}
