import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/speakers/speakers.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('SpeakersBloc', () {
    late FlutterconApi api;
    late SpeakersBloc speakersBloc;

    setUp(() {
      api = _MockFlutterconApi();
      speakersBloc = SpeakersBloc(api: api);
    });

    test('initial state is SpeakersInitial', () {
      expect(speakersBloc.state, equals(const SpeakersInitial()));
    });

    group('SpeakersRequested', () {
      blocTest<SpeakersBloc, SpeakersState>(
        'emits [SpeakersLoading, SpeakersLoaded] when successful',
        build: () => speakersBloc,
        act: (bloc) {
          when(() => api.getSpeakers()).thenAnswer(
            (_) async => TestData.speakerData,
          );
          bloc.add(const SpeakersRequested());
        },
        expect: () => [
          isA<SpeakersLoading>(),
          isA<SpeakersLoaded>().having(
            (state) => state.speakers,
            'Speakers',
            equals(TestData.speakerData.items),
          ),
        ],
      );

      blocTest<SpeakersBloc, SpeakersState>(
        'emits [SpeakersLoading, SpeakersError] when unsuccessful',
        build: () => speakersBloc,
        act: (bloc) {
          when(() => api.getSpeakers()).thenThrow(TestData.error);
          bloc.add(const SpeakersRequested());
        },
        expect: () => [
          isA<SpeakersLoading>(),
          isA<SpeakersError>().having(
            (state) => state.error,
            'Error',
            equals(TestData.error),
          ),
        ],
      );
    });
  });
}
