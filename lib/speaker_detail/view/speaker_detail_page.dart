import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/speaker_detail/speaker_detail.dart';
import 'package:fluttercon_usa_2024/talk_detail/talk_detail.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeakerDetailPage extends StatelessWidget {
  const SpeakerDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeakerDetailBloc(
        api: context.read<FlutterconApi>(),
        userId: context.read<UserCubit>().state?.id ?? '',
      )..add(SpeakerDetailRequested(id: id)),
      child: const SpeakerDetailView(),
    );
  }
}

@visibleForTesting
class SpeakerDetailView extends StatelessWidget {
  const SpeakerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SpeakerDetailBloc>().state;
    return switch (state) {
      SpeakerDetailInitial() || SpeakerDetailLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      SpeakerDetailError(error: final e) => Center(
          child: Text('$e'),
        ),
      SpeakerDetailLoaded(speaker: final speaker) =>
        SpeakerDetailContent(speaker: speaker),
    };
  }
}

@visibleForTesting
class SpeakerDetailContent extends StatelessWidget {
  const SpeakerDetailContent({required this.speaker, super.key});

  final SpeakerDetail speaker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final favoriteIds = context.select(
      (SpeakerDetailBloc bloc) {
        final state = bloc.state as SpeakerDetailLoaded;
        return state.favoriteIds;
      },
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SpeakerTile(
              name: speaker.name,
              title: speaker.title,
              imageUrl: speaker.imageUrl,
            ),
            const SizedBox(height: 16),
            Text(
              speaker.bio,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final link in speaker.links)
                  TextButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse(link.url));
                    },
                    child: Text(
                      link.type.name.toUpperCase(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            for (final talk in speaker.talks)
              BlocSelector<SpeakerDetailBloc, SpeakerDetailState, bool>(
                selector: (state) {
                  final favoriteIds =
                      (state as SpeakerDetailLoaded).favoriteIds;
                  return favoriteIds.contains(talk.id);
                },
                builder: (context, isFavorite) {
                  return TalkCard(
                    title: talk.title,
                    onTap: () async {
                      await Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (context) => TalkDetailPage(id: talk.id),
                        ),
                      );
                    },
                    speakerNames: talk.speakerNames,
                    room: talk.room,
                    onFavoriteTap: () {
                      final userId = context.read<UserCubit>().state?.id ?? '';
                      context.read<SpeakerDetailBloc>().add(
                            FavoriteToggleRequested(
                              userId: userId,
                              talkId: talk.id,
                              isFavorite: isFavorite,
                            ),
                          );
                    },
                    isFavorite: favoriteIds.contains(talk.id),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
