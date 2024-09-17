import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/favorites/favorites.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/test_data.dart';

class _MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

class _MockUserCubit extends MockCubit<User?> implements UserCubit {}

void main() {
  group('FavoritesPage', () {
    late UserCubit userCubit;

    setUp(() {
      userCubit = _MockUserCubit();
      when(() => userCubit.state).thenReturn(TestData.user);
      registerFallbackValue(
        RemoveFavoriteRequested(
          userId: TestData.user.id,
          talkId: '1',
        ),
      );
    });

    testWidgets('renders FavoritesView', (tester) async {
      await tester.pumpApp(
        const FavoritesPage(),
        userCubit: userCubit,
      );

      expect(find.byType(FavoritesView), findsOneWidget);
    });

    group('FavoritesView', () {
      late FavoritesBloc favoritesBloc;

      setUp(() {
        favoritesBloc = _MockFavoritesBloc();
      });

      testWidgets('renders CircularProgressIndicator when state is initial',
          (tester) async {
        when(() => favoritesBloc.state).thenReturn(const FavoritesInitial());

        await tester.pumpApp(
          BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesView(),
          ),
          userCubit: userCubit,
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders CircularProgressIndicator when state is loading',
          (tester) async {
        when(() => favoritesBloc.state).thenReturn(const FavoritesLoading());

        await tester.pumpApp(
          BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesView(),
          ),
          userCubit: userCubit,
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('renders Text with error message when state is error',
          (tester) async {
        when(() => favoritesBloc.state).thenReturn(
          FavoritesError(error: TestData.error),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesView(),
          ),
          userCubit: userCubit,
        );

        expect(find.text(TestData.error.toString()), findsOneWidget);
      });

      testWidgets('renders FavoritesSchedule when state is loaded',
          (tester) async {
        when(() => favoritesBloc.state).thenReturn(
          FavoritesLoaded(
            talks: TestData.talkTimeSlotData(favorites: true).items,
            favoriteIds: TestData.favoriteIds,
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesView(),
          ),
          userCubit: userCubit,
        );

        expect(find.byType(FavoritesSchedule), findsOneWidget);
      });

      testWidgets(
        'renders empty content when talks are empty',
        (tester) async {
          when(() => favoritesBloc.state).thenReturn(
            FavoritesLoaded(
              talks: [TalkTimeSlot(startTime: DateTime(2024), talks: const [])],
              favoriteIds: const [],
            ),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: favoritesBloc,
              child: const FavoritesView(),
            ),
            userCubit: userCubit,
          );

          expect(find.byType(TalkCard), findsNothing);
          expect(find.byType(SizedBox), findsOneWidget);
        },
      );

      group('FavoritesSchedule', () {
        testWidgets(
          'can tap $TalkCard to navigate to detail',
          (tester) async {
            when(() => favoritesBloc.state).thenReturn(
              FavoritesLoaded(
                talks: TestData.talkTimeSlotData(favorites: true).items,
                favoriteIds: TestData.favoriteIds,
              ),
            );

            await tester.pumpApp(
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: favoritesBloc,
                  ),
                  BlocProvider.value(
                    value: userCubit,
                  ),
                ],
                child: const FavoritesView(),
              ),
            );

            final card = find.byType(TalkCard).first;

            await tester.tap(card);

            await tester.pumpAndSettle();

            expect(find.byType(TalkDetailPage), findsOneWidget);
          },
        );

        testWidgets('can tap favorites icon to remove', (tester) async {
          when(() => favoritesBloc.state).thenReturn(
            FavoritesLoaded(
              talks: TestData.talkTimeSlotData().items,
              favoriteIds: TestData.favoriteIds,
            ),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: favoritesBloc,
              child: const FavoritesView(),
            ),
            userCubit: userCubit,
          );
          await tester.pumpAndSettle();

          final icon = find.byIcon(Icons.favorite).first;

          await tester.tap(icon);

          verify(
            () => favoritesBloc.add(
              any(
                that: isA<RemoveFavoriteRequested>(),
              ),
            ),
          ).called(1);
        });
      });
    });
  });
}
