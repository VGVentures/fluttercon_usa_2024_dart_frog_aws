import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';
import 'package:fluttercon_usa_2024/talk_detail/view/talk_detail_page.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/test_data.dart';

class _MockSpeakerDetailBloc
    extends MockBloc<SpeakerDetailEvent, SpeakerDetailState>
    implements SpeakerDetailBloc {}

void main() {
  group('SpeakerDetailPage', () {
    const speakerId = 'speakerId';
    final userId = TestData.user.id;

    testWidgets('renders SpeakerDetailView', (tester) async {
      await tester.pumpApp(
        SpeakerDetailPage(
          id: speakerId,
          userId: userId,
        ),
      );

      expect(find.byType(SpeakerDetailView), findsOneWidget);
    });

    group('SpeakerDetailView', () {
      late SpeakerDetailBloc speakerDetailBloc;

      setUp(() {
        speakerDetailBloc = _MockSpeakerDetailBloc();
      });

      testWidgets('renders CircularProgressIndicator when state is initial',
          (tester) async {
        when(() => speakerDetailBloc.state)
            .thenReturn(const SpeakerDetailInitial());

        await tester.pumpApp(
          BlocProvider.value(
            value: speakerDetailBloc,
            child: const SpeakerDetailView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders CircularProgressIndicator when state is loading',
          (tester) async {
        when(() => speakerDetailBloc.state)
            .thenReturn(const SpeakerDetailLoading());

        await tester.pumpApp(
          BlocProvider.value(
            value: speakerDetailBloc,
            child: const SpeakerDetailView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders SpeakerDetailContent when state is loaded',
          (tester) async {
        when(() => speakerDetailBloc.state)
            .thenReturn(SpeakerDetailLoaded(speaker: TestData.speakerDetail));

        await tester.pumpApp(
          BlocProvider.value(
            value: speakerDetailBloc,
            child: const SpeakerDetailView(),
          ),
        );

        expect(find.byType(SpeakerDetailContent), findsOneWidget);
      });

      group('SpeakerDetailContent', () {
        setUp(() {
          registerFallbackValue(
            FavoriteToggleRequested(
              userId: TestData.user.id,
              talkId: '1',
              isFavorite: false,
            ),
          );
        });
        testWidgets('can tap on $TalkCard to navigate to detail ',
            (tester) async {
          when(() => speakerDetailBloc.state).thenReturn(
            SpeakerDetailLoaded(speaker: TestData.speakerDetail),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: speakerDetailBloc,
              child: const SpeakerDetailView(),
            ),
          );

          await tester.tap(find.byType(TalkCard).first);
          await tester.pumpAndSettle();

          expect(find.byType(TalkDetailPage), findsOneWidget);
        });

        testWidgets('can tap favorites icon to toggle', (tester) async {
          when(() => speakerDetailBloc.state).thenReturn(
            SpeakerDetailLoaded(speaker: TestData.speakerDetail),
          );

          await tester.pumpApp(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: speakerDetailBloc,
                ),
              ],
              child: const SpeakerDetailView(),
            ),
          );

          final icon = find.byIcon(Icons.favorite_border).first;

          await tester.tap(icon);

          verify(
            () => speakerDetailBloc.add(
              any(
                that: isA<FavoriteToggleRequested>(),
              ),
            ),
          ).called(1);
        });

        testWidgets('can tap link to navigate to url', (tester) async {
          when(() => speakerDetailBloc.state).thenReturn(
            SpeakerDetailLoaded(speaker: TestData.speakerDetail),
          );

          await tester.pumpApp(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: speakerDetailBloc,
                ),
              ],
              child: const SpeakerDetailView(),
            ),
          );

          final link = find.text('OTHER');

          await tester.tap(link);

          verify(
            () => speakerDetailBloc.add(
              any(
                that: isA<SpeakerLinkTapped>(),
              ),
            ),
          ).called(1);
        });
      });
    });
  });
}
