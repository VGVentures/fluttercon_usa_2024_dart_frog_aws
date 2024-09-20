import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('SpeakerDetailBloc', () {
    late FlutterconApi api;
    late SpeakerDetailBloc speakerDetailBloc;
    const speakerId = 'speakerId';

    setUp(() {
      api = _MockFlutterconApi();
      speakerDetailBloc = SpeakerDetailBloc(
        api: api,
        userId: TestData.user.id,
      );
    });

    test('initial state is SpeakerDetailInitial', () {
      expect(speakerDetailBloc.state, const SpeakerDetailInitial());
    });

    group('SpeakerDetailRequested', () {
      blocTest<TalkDetailBloc, TalkDetailState>(
        'emits [TalkDetailLoading, TalkDetailLoaded] '
        'when successful',
        setUp: () {
          when(() => api.getTalk(id: talkId)).thenAnswer(
            (_) async => TestData.talkDetail,
          );
        },
        build: () => talkDetailBloc,
        act: (bloc) {
          bloc.add(const TalkDetailRequested(id: talkId));
        },
        expect: () => [
          isA<TalkDetailLoading>(),
          isA<TalkDetailLoaded>().having(
            (state) => state.talk,
            'Talk',
            equals(TestData.talkDetail),
          ),
        ],
      );

      blocTest<TalkDetailBloc, TalkDetailState>(
        'emits [TalkDetailLoading, TalkDetailError] '
        'when unsuccessful',
        setUp: () {
          when(() => api.getTalk(id: talkId)).thenThrow(TestData.error);
        },
        build: () => talkDetailBloc,
        act: (bloc) {
          bloc.add(const TalkDetailRequested(id: talkId));
        },
        expect: () => [
          isA<TalkDetailLoading>(),
          isA<TalkDetailError>().having(
            (state) => state.error,
            'error',
            equals(TestData.error),
          ),
        ],
      );
    });
  });
}
