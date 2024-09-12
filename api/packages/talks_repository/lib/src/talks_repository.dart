import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

/// The cache key for the talks cache.
const talksCacheKey = 'talks';

/// The cache key for the user Id of a favorites cache.
String favoritesUserCacheKey(String userId) => 'favorites_$userId';

/// {@template talks_repository}
/// A repository to cache and prepare talk data retrieved from the api.
/// {@endtemplate}
class TalksRepository {
  /// {@macro talks_repository}
  TalksRepository({
    required FlutterconDataSource dataSource,
    required FlutterconCache cache,
  })  : _dataSource = dataSource,
        _cache = cache;

  final FlutterconDataSource _dataSource;
  final FlutterconCache _cache;

  Favorites? _currentFavorites;

  /// Create a favorite talk entity
  /// from a [CreateFavoriteRequest].
  Future<CreateFavoriteResponse> createFavorite({
    required CreateFavoriteRequest request,
  }) async {
    final favorites = await _getFavoritesByUser(request.userId);

    final createResponse = await _dataSource.createFavoritesTalk(
      favoritesId: favorites.id,
      talkId: request.talkId,
    );

    return CreateFavoriteResponse(
      userId: createResponse.favorites?.userId ?? '',
      talkId: createResponse.talk?.id ?? '',
    );
  }

  /// Delete a favorite talk entity
  /// from a [DeleteFavoriteRequest].
  Future<DeleteFavoriteResponse> deleteFavorite({
    required DeleteFavoriteRequest request,
  }) async {
    final favorites = await _getFavoritesByUser(request.userId);

    final favoritesTalkResponse = await _dataSource.getFavoritesTalks(
      favoritesId: favorites.id,
      talkId: request.talkId,
    );

    if (favoritesTalkResponse.items.isEmpty ||
        favoritesTalkResponse.items.first == null) {
      return DeleteFavoriteResponse(
        userId: request.userId,
        talkId: request.talkId,
      );
    }

    final deleteResponse = await _dataSource.deleteFavoritesTalk(
      id: favoritesTalkResponse.items.first!.id,
    );

    return DeleteFavoriteResponse(
      userId: deleteResponse.favorites?.userId ?? '',
      talkId: deleteResponse.talk?.id ?? '',
    );
  }

  /// Fetches a paginated list of talks.
  /// Fetches from cache if available, and from api
  /// if the cache is empty.
  ///
  /// If fetching from api, the talks are then cached.
  /// Returns [TalkTimeSlot] objects with speaker information
  /// for each one.
  Future<PaginatedData<TalkTimeSlot>> getTalks({
    required String userId,
  }) async {
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

    final talks = talksResponse.items
        .where((talk) => talk != null)
        .map((talk) => talk!)
        .toList();

    final timeSlots = await _buildTalkTimeSlots(talks);

    final result = PaginatedData(
      items: timeSlots,
      limit: talksResponse.limit,
      nextToken: talksResponse.nextToken,
    );

    _currentFavorites ??= await _getFavoritesByUser(userId);

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
    final favorites = await _getFavoritesByUser(userId);

    final talks = (favorites.talks ?? [])
        .where((ft) => ft.talk != null)
        .map((ft) => ft.talk!)
        .toList();

    final timeSlots = await _buildTalkTimeSlots(talks);

    return PaginatedData(
      items: timeSlots,
    );
  }

  Future<List<TalkTimeSlot>> _buildTalkTimeSlots(List<Talk> talks) async {
    final talkPreviews = <TalkPreview>[];
    final timeSlots = <TalkTimeSlot>[];
    for (final talk in talks) {
      final speakerTalks = await _dataSource.getSpeakerTalks(talk: talk);
      final talkPreview = TalkPreview(
        id: talk.id,
        title: talk.title ?? '',
        room: talk.room ?? '',
        startTime: talk.startTime?.getDateTimeInUtc() ?? DateTime(2024),
        speakerNames:
            speakerTalks.items.map((st) => st?.speaker?.name ?? '').toList(),
        isFavorite: _currentFavorites?.talks?.contains(talk) ?? false,
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

  Future<Favorites> _getFavoritesByUser(String userId) async {
    Favorites favoritesUserData;

    final cachedFavorites = await _cache.get(favoritesUserCacheKey(userId));

    if (cachedFavorites != null) {
      final json = jsonDecode(cachedFavorites) as Map<String, dynamic>;
      favoritesUserData = Favorites.fromJson(json);
    } else {
      favoritesUserData = await _dataSource.createFavorites(
        userId: userId,
      );
      await _cache.set(
        favoritesUserCacheKey(userId),
        jsonEncode(favoritesUserData.toJson()),
      );
    }

    final favoritesTalksResponse =
        await _dataSource.getFavoritesTalks(favoritesId: favoritesUserData.id);

    final favoritesTalks = favoritesTalksResponse.items
        .where((ft) => ft != null)
        .map((ft) => ft!)
        .toList();

    return _currentFavorites ??=
        favoritesUserData.copyWith(talks: favoritesTalks);
  }
}
