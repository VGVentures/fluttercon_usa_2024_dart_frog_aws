import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('TalksBloc', () {
    late FlutterconApi api;
    late TalksBloc talksBloc;

    setUp(() {
      api = _MockFlutterconApi();
      talksBloc = TalksBloc(api: api);
    });

    test('initial state is TalksInitial', () {
      expect(talksBloc.state, equals(const TalksInitial()));
    });

    group('TalksRequested', () {
      blocTest<TalksBloc, TalksState>(
        'emits [TalksLoading, TalksLoaded] when successful',
        build: () => talksBloc,
        act: (bloc) {
          when(() => api.getTalks()).thenAnswer(
            (_) async => TestData.talkTimeSlotData,
          );
          bloc.add(const TalksRequested());
        },
        expect: () => [
          isA<TalksLoading>(),
          isA<TalksLoaded>().having(
            (state) => state.talkTimeSlots,
            'TalkTimeSlots',
            equals(TestData.talkTimeSlotData.items),
          ),
        ],
      );

      blocTest<TalksBloc, TalksState>(
        'emits [TalksLoading, TalksError] when unsuccessful',
        build: () => talksBloc,
        act: (bloc) {
          when(() => api.getTalks()).thenThrow(TestData.error);
          bloc.add(const TalksRequested());
        },
        expect: () => [
          isA<TalksLoading>(),
          isA<TalksError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });
  });
}
