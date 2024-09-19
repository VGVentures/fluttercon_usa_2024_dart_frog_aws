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
  Future<PaginatedData<SpeakerPreview>> getSpeakers() async => _cache.getOrElse(
        key: speakersCacheKey,
        // coverage:ignore-start
        fromJson: (json) => PaginatedData.fromJson(
          json,
          (val) => SpeakerPreview.fromJson((val ?? {}) as Map<String, dynamic>),
        ),
        orElse: getSpeakersFromApi,
        // coverage:ignore-end
      );

  /// Fetches a [SpeakerDetail] with a given [id].
  /// Requires a [userId] to determine if the speaker's talks
  /// are included in the current user's favorites.
  Future<SpeakerDetail> getSpeaker({
    required String id,
    required String userId,
  }) async {
    return _cache.getOrElse(
      key: speakerCacheKey(id),
      fromJson: SpeakerDetail.fromJson,
      orElse: () => getSpeakerDetailFromApi(id: id, userId: userId),
    );
  }

  /// Fetches a paginated list of speakers from the api.
  Future<PaginatedData<SpeakerPreview>> getSpeakersFromApi() async {
    final speakers = await _dataSource.getSpeakers();

    final speakerPreviews = speakers.items
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
      limit: speakers.limit,
      nextToken: speakers.nextToken,
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

  /// Fetches a [SpeakerDetail] from the api with a given [id] and
  /// the current [userId].
  Future<SpeakerDetail> getSpeakerDetailFromApi({
    required String id,
    required String userId,
  }) async {
    final speaker = await _dataSource.getSpeaker(id: id);
    final links = await _dataSource.getLinks(speaker: speaker);

    final talks = await _dataSource.getSpeakerTalks(
      speakers: [speaker],
    );
    final speakers = await _dataSource.getSpeakerTalks(
      talks: talks.items
          .where((st) => st?.talk != null)
          .map((st) => st!.talk!)
          .toList(),
    );

    final favorites = await _cache.getOrElse(
      key: favoritesCacheKey(userId),
      // coverage:ignore-start
      fromJson: favoritesFromJson,
      orElse: () async {
        final response = await _dataSource.getFavorites(userId: userId);
        return response.items.first;
        // coverage:ignore-end
      },
    );

    final result = SpeakerDetail(
      id: speaker.id,
      name: speaker.name ?? '',
      title: speaker.title ?? '',
      bio: speaker.bio ?? '',
      imageUrl: speaker.imageUrl ?? '',
      links: links.items
          .map(
            (link) => SpeakerLink(
              id: link?.id ?? '',
              url: link?.url ?? '',
              type: link?.type?.toSpeakerLinkType ?? SpeakerLinkType.other,
            ),
          )
          .toList(),
      talks: talks.items.map(
        (st) {
          return TalkPreview(
            id: st?.talk?.id ?? '',
            title: st?.talk?.title ?? '',
            room: st?.talk?.room ?? '',
            startTime:
                st?.talk?.startTime?.getDateTimeInUtc() ?? DateTime(2024),
            speakerNames: speakers.items
                .where((st) => st?.talk?.id == st?.talk?.id)
                .map((st) => st?.speaker?.name ?? '')
                .toList(),
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
