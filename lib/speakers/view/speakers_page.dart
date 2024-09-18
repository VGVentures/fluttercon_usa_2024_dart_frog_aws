import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:fluttercon_usa_2024/speaker_detail/view/speaker_detail_page.dart';
import 'package:fluttercon_usa_2024/speakers/speakers.dart';
import 'package:fluttercon_usa_2024/widgets/widgets.dart';

class SpeakersPage extends StatelessWidget {
  const SpeakersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpeakersBloc(api: context.read<FlutterconApi>())
        ..add(const SpeakersRequested()),
      child: const SpeakersView(),
    );
  }
}

@visibleForTesting
class SpeakersView extends StatelessWidget {
  const SpeakersView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SpeakersBloc>().state;
    return switch (state) {
      SpeakersInitial() || SpeakersLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      SpeakersError(error: final e) => Center(
          child: Text('$e'),
        ),
      SpeakersLoaded(speakers: final speakers) => SpeakersList(
          speakers: speakers,
        ),
    };
  }
}

@visibleForTesting
class SpeakersList extends StatelessWidget {
  const SpeakersList({
    required this.speakers,
    super.key,
  });

  final List<SpeakerPreview> speakers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: speakers.length,
      itemBuilder: (context, index) {
        final speaker = speakers[index];
        return SpeakerTile(
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
        );
      },
    );
  }
}
