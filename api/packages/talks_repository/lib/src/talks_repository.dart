import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

/// The cache key for the talks cache.
const talksCacheKey = 'talks';

/// {@template talks_repository}
/// A repository to cache and prepare talk data retrieved from the api.
/// {@endtemplate}
class TalksRepository {
  /// {@macro talks_repository}
  const TalksRepository({
    required FlutterconDataSource dataSource,
    required FlutterconCache cache,
  })  : _dataSource = dataSource,
        _cache = cache;

  final FlutterconDataSource _dataSource;
  final FlutterconCache _cache;

  /// Fetches a paginated list of talks.
  /// Fetches from cache if available, and from api
  /// if the cache is empty.
  ///
  /// If fetching from api, the talks are then cached.
  /// Returns [TalkTimeSlot] objects with speaker information
  /// for each one.
  Future<PaginatedData<TalkTimeSlot>> getTalks() async {
    final cachedTalks = await _cache.get(talksCacheKey);

    if (cachedTalks != null) {
      final json = jsonDecode(cachedTalks) as Map<String, dynamic>;
      final result = PaginatedData.fromJson(
        json,
        (val) => TalkTimeSlot.fromJson((val ?? {}) as Map<String, dynamic>),
      );

      return result;
    }

    final talksResponse = await _dataSource.getTalks();

    final timeSlots = await _buildTalkTimeSlots(talksResponse.items);

    final result = PaginatedData(
      items: timeSlots,
      limit: talksResponse.limit,
      nextToken: talksResponse.nextToken,
    );

    await _cache.set(
      talksCacheKey,
      jsonEncode(
        result.toJson(
          (val) => val.toJson(),
        ),
      ),
    );
    return result;
  }

  /// Fetches a paginated list of talks for a given [userId].
  ///
  ///  Returns [TalkTimeSlot] objects with speaker information
  /// for each one.
  Future<PaginatedData<TalkTimeSlot>> getFavorites({
    required String userId,
  }) async {
    final favoritesResponse = await _dataSource.getFavorites(userId: userId);

    if (favoritesResponse.items.isEmpty ||
        favoritesResponse.items.first == null) {
      return PaginatedData(
        items: const [],
        limit: favoritesResponse.limit,
        nextToken: favoritesResponse.nextToken,
      );
    }

    final favorites = favoritesResponse.items.first!;

    final favoritesTalks =
        await _dataSource.getFavoritesTalks(favoritesId: favorites.id);

    final talksResponse = await _dataSource.getTalks(
      ids: favoritesTalks.items
          .map((ft) => ft?.talk?.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
    );

    final timeSlots = await _buildTalkTimeSlots(talksResponse.items);

    return PaginatedData(
      items: timeSlots,
      limit: favoritesTalks.limit,
      nextToken: favoritesTalks.nextToken,
    );
  }

  Future<List<TalkTimeSlot>> _buildTalkTimeSlots(List<Talk?> talks) async {
    final talkPreviews = <TalkPreview>[];
    final timeSlots = <TalkTimeSlot>[];
    for (final talk in talks) {
      final id = talk?.id;
      if (id == null) continue;
      final speakerTalks = await _dataSource.getSpeakerTalks(talk: talk);
      final talkPreview = TalkPreview(
        id: talk!.id,
        title: talk.title ?? '',
        room: talk.room ?? '',
        startTime: talk.startTime?.getDateTimeInUtc() ?? DateTime(2024),
        speakerNames:
            speakerTalks.items.map((st) => st?.speaker?.name ?? '').toList(),
      );
      talkPreviews.add(talkPreview);
    }

    final times = talkPreviews.map((t) => t.startTime).toSet();

    for (final time in times) {
      final talksForTime =
          talkPreviews.where((t) => t.startTime == time).toList();
      final timeSlot = TalkTimeSlot(
        startTime: time,
        talks: talksForTime,
      );
      timeSlots.add(timeSlot);
    }

    final sortedTimeSlots = [...timeSlots]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return sortedTimeSlots;
  }
}
