import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';
import 'package:intl/intl.dart';

class TalksPage extends StatelessWidget {
  const TalksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TalksBloc(api: context.read<FlutterconApi>())
        ..add(const TalksRequested()),
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
          child: Text('Error: $e'),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                DateFormat('MMM dd hh:mm:a')
                    .format(timeSlot.startTime.toLocal()),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: timeSlot.talks
                  .map(
                    (talk) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(talk.title),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite_border),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  talk.speakerNames.join(', '),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  talk.room,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
