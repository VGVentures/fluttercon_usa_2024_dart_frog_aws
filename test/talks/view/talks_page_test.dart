import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/test_data.dart';

class _MockTalksBloc extends MockBloc<TalksEvent, TalksState>
    implements TalksBloc {}

void main() {
  group('TalksPage', () {
    testWidgets('renders TalksView', (tester) async {
      await tester.pumpApp(const TalksPage());

      expect(find.byType(TalksView), findsOneWidget);
    });

    group('TalksView', () {
      late TalksBloc talksBloc;

      setUp(() {
        talksBloc = _MockTalksBloc();
      });

      testWidgets('renders CircularProgressIndicator when state is initial',
          (tester) async {
        when(() => talksBloc.state).thenReturn(const TalksInitial());

        await tester.pumpApp(
          BlocProvider.value(
            value: talksBloc,
            child: const TalksView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders CircularProgressIndicator when state is loading',
          (tester) async {
        when(() => talksBloc.state).thenReturn(const TalksLoading());

        await tester.pumpApp(
          BlocProvider.value(
            value: talksBloc,
            child: const TalksView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders Text with error message when state is error',
          (tester) async {
        when(() => talksBloc.state).thenReturn(
          TalksError(error: TestData.error),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: talksBloc,
            child: const TalksView(),
          ),
        );

        expect(find.text(TestData.error.toString()), findsOneWidget);
      });

      testWidgets('renders Text with error message when state is error',
          (tester) async {
        when(() => talksBloc.state).thenReturn(
          TalksError(error: TestData.error),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: talksBloc,
            child: const TalksView(),
          ),
        );

        expect(find.text(TestData.error.toString()), findsOneWidget);
      });

      testWidgets('renders TalksSchedule when state is loaded', (tester) async {
        when(() => talksBloc.state).thenReturn(
          TalksLoaded(talkTimeSlots: TestData.talkTimeSlotData.items),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: talksBloc,
            child: const TalksView(),
          ),
        );

        expect(find.byType(TalksSchedule), findsOneWidget);
      });

      group('TalksSchedule', () {
        testWidgets('can tap favorites icon', (tester) async {
          when(() => talksBloc.state).thenReturn(
            TalksLoaded(talkTimeSlots: TestData.talkTimeSlotData.items),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: talksBloc,
              child: const TalksView(),
            ),
          );

          final icon = find.byIcon(Icons.favorite_border).first;

          await tester.tap(icon);
          expect(
            tester.widget<Icon>(icon).icon,
            equals(Icons.favorite_border),
          );
        });
      });
    });
  });
}
