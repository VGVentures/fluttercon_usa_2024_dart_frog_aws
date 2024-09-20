import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';
import 'package:fluttercon_usa_2024/speakers/speakers.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/test_data.dart';

class _MockSpeakersBloc extends MockBloc<SpeakersEvent, SpeakersState>
    implements SpeakersBloc {}

class _MockUserCubit extends MockCubit<User?> implements UserCubit {}

void main() {
  group('SpeakersPage', () {
    testWidgets('renders SpeakersView', (tester) async {
      await tester.pumpApp(const SpeakersPage());

      expect(find.byType(SpeakersView), findsOneWidget);
    });

    group('SpeakersView', () {
      late SpeakersBloc speakersBloc;

      setUp(() {
        speakersBloc = _MockSpeakersBloc();
      });

      testWidgets('renders CircularProgressIndicator when state is initial',
          (tester) async {
        when(() => speakersBloc.state).thenReturn(const SpeakersInitial());

        await tester.pumpApp(
          BlocProvider.value(
            value: speakersBloc,
            child: const SpeakersView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders CircularProgressIndicator when state is loading',
          (tester) async {
        when(() => speakersBloc.state).thenReturn(const SpeakersLoading());

        await tester.pumpApp(
          BlocProvider.value(
            value: speakersBloc,
            child: const SpeakersView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders Text with error message when state is error',
          (tester) async {
        when(() => speakersBloc.state).thenReturn(
          SpeakersError(error: TestData.error),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: speakersBloc,
            child: const SpeakersView(),
          ),
        );

        expect(find.text(TestData.error.toString()), findsOneWidget);
      });

      testWidgets('renders SpeakersList when state is loaded', (tester) async {
        when(() => speakersBloc.state).thenReturn(
          SpeakersLoaded(speakers: TestData.speakerData.items),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: speakersBloc,
            child: const SpeakersView(),
          ),
        );

        expect(find.byType(SpeakersList), findsOneWidget);
      });

      group('SpeakersList', () {
        late UserCubit userCubit;

        setUp(() {
          userCubit = _MockUserCubit();
          when(() => userCubit.state).thenReturn(TestData.user);
        });

        testWidgets('can tap $SpeakerTile to navigate to detail',
            (tester) async {
          when(() => speakersBloc.state).thenReturn(
            SpeakersLoaded(speakers: TestData.speakerData.items),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: speakersBloc,
              child: const SpeakersView(),
            ),
            userCubit: userCubit,
          );

          await tester.tap(find.byType(SpeakerTile).first);
          await tester.pumpAndSettle();

          expect(find.byType(SpeakerDetailPage), findsOneWidget);
        });
      });
    });
  });
}
