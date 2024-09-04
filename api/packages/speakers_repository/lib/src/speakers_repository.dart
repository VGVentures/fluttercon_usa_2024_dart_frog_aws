import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

/// The cache key for the speakers cache.
const speakersCacheKey = 'speakers';

/// {@template speakers_repository}
/// A repository to cache and prepare speaker data retrieved from the api.
/// {@endtemplate}
class SpeakersRepository {
  /// {@macro speakers_repository}
  const SpeakersRepository({
    required FlutterconDataSource dataSource,
    required FlutterconCache cache,
  })  : _dataSource = dataSource,
        _cache = cache;

  final FlutterconDataSource _dataSource;
  final FlutterconCache _cache;

  /// Fetches a paginated list of speakers.
  /// Fetches from cache if available, and from api
  /// if the cache is empty.
  ///
  /// If fetching from api, the speakers are then cached.
  Future<PaginatedData<SpeakerPreview>> getSpeakers() async {
    final cachedSpeakers = await _cache.get(speakersCacheKey);

    if (cachedSpeakers != null) {
      final json = jsonDecode(cachedSpeakers) as Map<String, dynamic>;
      final result = PaginatedData.fromJson(
        json,
        (val) => SpeakerPreview.fromJson((val ?? {}) as Map<String, dynamic>),
      );

      return result;
    }

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

    final result = PaginatedData(
      items: sortedSpeakerPreviews,
      limit: speakersResponse.limit,
      nextToken: speakersResponse.nextToken,
    );

    await _cache.set(
      speakersCacheKey,
      jsonEncode(
        result.toJson(
          (val) => val.toJson(),
        ),
      ),
    );

    return result;
  }
}
