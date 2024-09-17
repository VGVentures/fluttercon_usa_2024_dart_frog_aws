// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';

import '../../helpers/test_data.dart';

void main() {
  group('TalkDetailState', () {
    group('TalkDetailInitial', () {
      test('supports value equality', () {
        expect(
          TalkDetailInitial(),
          equals(TalkDetailInitial()),
        );
      });
    });

    group('TalkDetailLoading', () {
      test('supports value equality', () {
        expect(
          TalkDetailLoading(),
          equals(TalkDetailLoading()),
        );
      });
    });

    group('TalkDetailLoaded', () {
      test('supports value equality', () {
        expect(
          TalkDetailLoaded(talk: TestData.talkDetail),
          equals(TalkDetailLoaded(talk: TestData.talkDetail)),
        );
      });

      group('copyWith', () {
        test('returns same object when copyWith is called with no params', () {
          final state = TalkDetailLoaded(talk: TestData.talkDetail);
          expect(state, equals(state.copyWith()));
        });

        test('returns object with updated talk when copyWith is called', () {
          final state = TalkDetailLoaded(talk: TestData.talkDetail);
          final updatedTalk = TalkDetail(
            id: 'id',
            title: 'new title',
            room: 'room',
            startTime: DateTime(2024),
            speakers: const [],
            description: 'description',
          );
          final updatedState = state.copyWith(talk: updatedTalk);
          expect(updatedState.talk, equals(updatedTalk));
        });
      });
    });

    group('TalkDetailError', () {
      test('supports value equality', () {
        expect(
          TalkDetailError(error: TestData.error),
          equals(TalkDetailError(error: TestData.error)),
        );
      });
    });
  });
}
