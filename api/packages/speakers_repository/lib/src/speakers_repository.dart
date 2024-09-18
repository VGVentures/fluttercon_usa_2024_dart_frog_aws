import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

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

  /// Fetches a [SpeakerDetail] with a given [id].
  /// Requires a [userId] to determine if the speaker's talks
  /// are included in the current user's favorites.
  Future<SpeakerDetail> getSpeaker({
    required String id,
    required String userId,
  }) async {
    final cachedSpeaker = await _cache.get(speakerCacheKey(id));

    if (cachedSpeaker != null) {
      final json = jsonDecode(cachedSpeaker) as Map<String, dynamic>;
      final result = SpeakerDetail.fromJson(json);

      return result;
    }

    final speakerResponse = await _dataSource.getSpeaker(id: id);
    final linksResponse = await _dataSource.getLinks(speaker: speakerResponse);

    //this is gross. Get talks for speaker then get speakers for talks.
    // Will usually end up giving us the same data we already have.
    // Can we do this a better way?
    final talksForSpeakerResponse = await _dataSource.getSpeakerTalks(
      speaker: speakerResponse,
    );
    PaginatedResult<SpeakerTalk>? speakersForTalkResponse;
    for (final speakerTalk in talksForSpeakerResponse.items) {
      speakersForTalkResponse = await _dataSource.getSpeakerTalks(
        talk: speakerTalk?.talk,
      );
    }

    final favorites = await _cache.getOrElse(
      key: favoritesCacheKey(userId),
      fromJson: favoritesFromJson,
      orElse: () async {
        final response = await _dataSource.getFavorites(userId: userId);
        return response.items.first;
      },
    );

    final result = SpeakerDetail(
      id: speakerResponse.id,
      name: speakerResponse.name ?? '',
      title: speakerResponse.title ?? '',
      bio: speakerResponse.bio ?? '',
      imageUrl: speakerResponse.imageUrl ?? '',
      links: linksResponse.items
          .map(
            (link) => SpeakerLink(
              id: link?.id ?? '',
              url: link?.url ?? '',
              type: link?.type?.toSpeakerLinkType ?? SpeakerLinkType.other,
            ),
          )
          .toList(),
      talks: talksForSpeakerResponse.items.map(
        (st) {
          return TalkPreview(
            id: st?.talk?.id ?? '',
            title: st?.talk?.title ?? '',
            room: st?.talk?.room ?? '',
            startTime:
                st?.talk?.startTime?.getDateTimeInUtc() ?? DateTime(2024),
            speakerNames: speakersForTalkResponse?.items
                    .map((st) => st?.speaker?.name ?? '')
                    .toList() ??
                [],
            isFavorite:
                favorites?.talks?.any((ft) => ft.talk == st?.talk) ?? false,
          );
        },
      ).toList(),
    );

    await _cache.set(
      speakerCacheKey(id),
      jsonEncode(result.toJson()),
    );

    return result;
  }
}

/// An extension to convert [LinkType] value to [SpeakerLinkType].
extension ToSpeakerLinkType on LinkType {
  /// Converts a [LinkType] to a [SpeakerLinkType].
  SpeakerLinkType get toSpeakerLinkType {
    return switch (this) {
      LinkType.github => SpeakerLinkType.github,
      LinkType.linkedin => SpeakerLinkType.linkedIn,
      LinkType.twitter => SpeakerLinkType.twitter,
      LinkType.other => SpeakerLinkType.other,
    };
  }
}
