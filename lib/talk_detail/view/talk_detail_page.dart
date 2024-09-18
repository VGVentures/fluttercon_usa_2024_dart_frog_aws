import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/speaker_detail/view/speaker_detail_page.dart';
import 'package:fluttercon_usa_2024/talk_detail/bloc/talk_detail_bloc.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';

class TalkDetailPage extends StatelessWidget {
  const TalkDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TalkDetailBloc(
        api: context.read<FlutterconApi>(),
      )..add(TalkDetailRequested(id: id)),
      child: const TalkDetailView(),
    );
  }
}

@visibleForTesting
class TalkDetailView extends StatelessWidget {
  const TalkDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TalkDetailBloc>().state;
    return switch (state) {
      TalkDetailInitial() || TalkDetailLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      TalkDetailError(error: final e) => Center(
          child: Text('$e'),
        ),
      TalkDetailLoaded(talk: final talk) => TalkDetailContent(talk: talk),
    };
  }
}

@visibleForTesting
class TalkDetailContent extends StatelessWidget {
  const TalkDetailContent({required this.talk, super.key});

  final TalkDetail talk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              talk.title,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TimeLabel(time: talk.startTime),
            Text(talk.room, style: theme.textTheme.bodyMedium),
            for (final speaker in talk.speakers)
              SpeakerTile(
                name: speaker.name,
                title: speaker.title,
                imageUrl: speaker.imageUrl,
                onTap: () async {
                  await Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => SpeakerDetailPage(id: speaker.id),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              talk.description,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
