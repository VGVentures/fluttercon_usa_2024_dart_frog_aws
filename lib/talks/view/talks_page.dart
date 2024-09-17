import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';

class TalksPage extends StatelessWidget {
  const TalksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TalksBloc(
        api: context.read<FlutterconApi>(),
      )..add(const TalksRequested()),
      child: const TalksView(),
    );
  }
}

@visibleForTesting
class TalksView extends StatelessWidget {
  const TalksView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TalksBloc>().state;
    return switch (state) {
      TalksInitial() || TalksLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      TalksError(error: final e) => Center(
          child: Text('$e'),
        ),
      TalksLoaded(talkTimeSlots: final talkTimeSlots) => TalksSchedule(
          talkTimeSlots: talkTimeSlots,
        ),
    };
  }
}

@visibleForTesting
class TalksSchedule extends StatelessWidget {
  const TalksSchedule({required this.talkTimeSlots, super.key});

  final List<TalkTimeSlot> talkTimeSlots;

  @override
  Widget build(BuildContext context) {
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
                    .map(
                      (talk) => BlocSelector<TalksBloc, TalksState, bool>(
                        selector: (state) {
                          final favoriteIds =
                              (state as TalksLoaded).favoriteIds;
                          return favoriteIds.contains(talk.id);
                        },
                        builder: (context, isFavorite) {
                          return TalkCard(
                            title: talk.title,
                            speakerNames: talk.speakerNames,
                            room: talk.room,
                            isFavorite: isFavorite,
                            onTap: () async {
                              await Navigator.of(context).push<void>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TalkDetailPage(id: talk.id),
                                ),
                              );
                            },
                            onFavoriteTap: () {
                              final userId =
                                  context.read<UserCubit>().state?.id ?? '';
                              context.read<TalksBloc>().add(
                                    FavoriteToggleRequested(
                                      userId: userId,
                                      talkId: talk.id,
                                      isFavorite: isFavorite,
                                    ),
                                  );
                            },
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
