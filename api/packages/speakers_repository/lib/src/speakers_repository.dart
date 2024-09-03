import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

/// {@template speakers_repository}
/// A repository to cache and prepare speaker data retrieved from the api.
/// {@endtemplate}
class SpeakersRepository {
  /// {@macro speakers_repository}
  const SpeakersRepository({
    required FlutterconDataSource dataSource,
  }) : _dataSource = dataSource;

  final FlutterconDataSource _dataSource;

  /// Fetches a paginated list of speakers from the data source.
  Future<PaginatedData<SpeakerPreview>> getSpeakers() async {
    final speakersResponse = await _dataSource.getSpeakers();

    final speakerPreviews = speakersResponse.items
        .map(
          (speaker) => SpeakerPreview(
            id: speaker?.id ?? '',
            name: speaker?.name ?? '',
            title: speaker?.title ?? '',
            imageUrl: speaker?.imageUrl ?? '',
          ),
        )
        .toList();

    final sortedSpeakerPreviews = [...speakerPreviews]
      ..sort((a, b) => a.name.compareTo(b.name));

    return PaginatedData(
      items: sortedSpeakerPreviews,
      limit: speakersResponse.limit,
      nextToken: speakersResponse.nextToken,
    );
  }
}
