import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/favorites/favorites.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc(
        api: context.read<FlutterconApi>(),
        userId: context.read<UserCubit>().state?.id ?? '',
      )..add(const FavoritesRequested()),
      child: const FavoritesView(),
    );
  }
}

@visibleForTesting
class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FavoritesBloc>().state;
    return switch (state) {
      FavoritesInitial() || FavoritesLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      FavoritesError(error: final e) => Center(
          child: Text('$e'),
        ),
      FavoritesLoaded(talks: final talkTimeSlots) => FavoritesSchedule(
          talkTimeSlots: talkTimeSlots,
        ),
    };
  }
}

@visibleForTesting
class FavoritesSchedule extends StatelessWidget {
  const FavoritesSchedule({required this.talkTimeSlots, super.key});

  final List<TalkTimeSlot> talkTimeSlots;

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.select(
      (FavoritesBloc bloc) => (bloc.state as FavoritesLoaded).favoriteIds,
    );

    if (favoriteIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: talkTimeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = talkTimeSlots[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TimeLabel(time: timeSlot.startTime),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: timeSlot.talks
                    .where((talk) => favoriteIds.contains(talk.id))
                    .map(
                      (talk) => TalkCard(
                        title: talk.title,
                        speakerNames: talk.speakerNames,
                        room: talk.room,
                        isFavorite: true,
                        onFavoriteTap: () {
                          final userId =
                              context.read<UserCubit>().state?.id ?? '';
                          context.read<FavoritesBloc>().add(
                                RemoveFavoriteRequested(
                                  userId: userId,
                                  talkId: talk.id,
                                ),
                              );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
