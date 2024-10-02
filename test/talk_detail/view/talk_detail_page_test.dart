import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/speaker_detail/view/speaker_detail_page.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/test_data.dart';

class _MockTalkDetailBloc extends MockBloc<TalkDetailEvent, TalkDetailState>
    implements TalkDetailBloc {}

void main() {
  group('TalkDetailPage', () {
    const talkId = 'talkId';
    testWidgets('renders TalkDetailView', (tester) async {
      await tester.pumpApp(const TalkDetailPage(id: talkId));

      expect(find.byType(TalkDetailView), findsOneWidget);
    });

    group('TalkDetailView', () {
      late TalkDetailBloc talkDetailBloc;

      setUp(() {
        talkDetailBloc = _MockTalkDetailBloc();
      });

      testWidgets('renders CircularProgressIndicator when state is initial',
          (tester) async {
        when(() => talkDetailBloc.state).thenReturn(const TalkDetailInitial());

        await tester.pumpApp(
          BlocProvider.value(
            value: talkDetailBloc,
            child: const TalkDetailView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders CircularProgressIndicator when state is loading',
          (tester) async {
        when(() => talkDetailBloc.state).thenReturn(const TalkDetailLoading());

        await tester.pumpApp(
          BlocProvider.value(
            value: talkDetailBloc,
            child: const TalkDetailView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders TalkDetailContent when state is loaded',
          (tester) async {
        when(() => talkDetailBloc.state)
            .thenReturn(TalkDetailLoaded(talk: TestData.talkDetail));

        await tester.pumpApp(
          BlocProvider.value(
            value: talkDetailBloc,
            child: const TalkDetailView(),
          ),
        );

        expect(find.byType(TalkDetailContent), findsOneWidget);
      });

      group('TalkDetailContent', () {
        testWidgets('can tap $SpeakerTile to navigate to detail',
            (tester) async {
          await tester.pumpApp(
            TalkDetailContent(talk: TestData.talkDetail),
          );

          await tester.tap(find.byType(SpeakerTile).first);
          await tester.pumpAndSettle();

          expect(find.byType(SpeakerDetailPage), findsOneWidget);
        });
      });
    });
  });
}
