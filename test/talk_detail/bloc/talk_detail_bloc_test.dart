import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('TalkDetailBloc', () {
    late FlutterconApi api;
    late TalkDetailBloc talkDetailBloc;
    const talkId = 'talkId';

    setUp(() {
      api = _MockFlutterconApi();
      talkDetailBloc = TalkDetailBloc(api: api);
    });

    test('initial state is TalkDetailInitial', () {
      expect(talkDetailBloc.state, const TalkDetailInitial());
    });

    group('TalkDetailRequested', () {
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
