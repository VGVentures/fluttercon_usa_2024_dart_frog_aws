import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

/// The cache key for the talks cache.
const talksCacheKey = 'talks';

/// The cache key for the favorites corresponding to a [userId].
String favoritesCacheKey(String userId) => 'favorites_$userId';

/// The cache key for an individual cached talk.
String talkCacheKey(String id) => 'talk_$id';

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

  /// Create a favorite talk entity
  /// from a [CreateFavoriteRequest].
  Future<CreateFavoriteResponse> createFavorite({
    required CreateFavoriteRequest request,
  }) async {
    final favorites = await _tryGetFromCache(
      key: favoritesCacheKey(request.userId),
      fromJson: _favoritesFromJson,
      orElse: () async => _getFavoritesByUser(request.userId),
    );

    final createResponse = await _dataSource.createFavoritesTalk(
      favoritesId: favorites.id,
      talkId: request.talkId,
    );

    final newFavorites = favorites.copyWith(
      talks: [...favorites.talks ?? [], createResponse],
    );

    await _cache.set(
      favoritesCacheKey(request.userId),
      jsonEncode(newFavorites.toJson()),
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
    final favorites = await _tryGetFromCache(
      key: favoritesCacheKey(request.userId),
      fromJson: _favoritesFromJson,
      orElse: () async => _getFavoritesByUser(request.userId),
    );

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

    final newFavorites = favorites.copyWith(
      talks:
          favorites.talks?.where((ft) => ft.id != deleteResponse.id).toList(),
    );

    await _cache.set(
      favoritesCacheKey(request.userId),
      jsonEncode(newFavorites.toJson()),
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
    final talkData = await _tryGetFromCache(
      key: talksCacheKey,
      fromJson: (json) => PaginatedData.fromJson(
        json,
        (val) => Talk.fromJson((val ?? {}) as Map<String, dynamic>),
      ),
      orElse: () async {
        final response = await _dataSource.getTalks();
        final data = PaginatedData(
          items: response.items,
          limit: response.limit,
          nextToken: response.nextToken,
        );
        await _cache.set(
          talksCacheKey,
          jsonEncode(
            data.toJson(
              (val) => val?.toJson(),
            ),
          ),
        );
        return data;
      },
    );

    final favorites = await _tryGetFromCache(
      key: favoritesCacheKey(userId),
      fromJson: _favoritesFromJson,
      orElse: () async => _getFavoritesByUser(userId),
    );

    final timeSlots =
        await _buildTalkTimeSlots(talkData.items, favorites.talks ?? []);

    return PaginatedData(
      items: timeSlots,
      limit: talkData.limit,
      nextToken: talkData.nextToken,
    );
  }

  /// Fetches a [TalkDetail] entity by [id].
  Future<TalkDetail> getTalk({required String id}) async {
    return _tryGetFromCache(
      key: talkCacheKey(id),
      fromJson: TalkDetail.fromJson,
      orElse: () async {
        final talk = await _dataSource.getTalk(id: id);
        final speakerTalks = await _dataSource.getSpeakerTalks(
          talk: talk,
        );
        final detail = TalkDetail(
          id: id,
          title: talk.title ?? '',
          room: talk.room ?? '',
          startTime: talk.startTime?.getDateTimeInUtc() ?? DateTime(2024),
          speakers: speakerTalks.items
              .map(
                (st) => SpeakerPreview(
                  id: st?.speaker?.id ?? '',
                  name: st?.speaker?.name ?? '',
                  title: st?.speaker?.title ?? '',
                  imageUrl: st?.speaker?.imageUrl ?? '',
                ),
              )
              .toList(),
          description: talk.description ?? '',
        );

        await _cache.set(
          'talk_$id',
          jsonEncode(detail.toJson()),
        );
        return detail;
      },
    );
  }

  /// Fetches a paginated list of talks for a given [userId].
  ///
  ///  Returns [TalkTimeSlot] objects with speaker information
  /// for each one.
  Future<PaginatedData<TalkTimeSlot>> getFavorites({
    required String userId,
  }) async {
    final favorites = await _tryGetFromCache(
      key: favoritesCacheKey(userId),
      fromJson: _favoritesFromJson,
      orElse: () async => _getFavoritesByUser(userId),
    );

    final favoritesTalks = favorites.talks ?? [];

    final talks = favoritesTalks
        .where((ft) => ft.talk != null)
        .map((ft) => ft.talk!)
        .toList();

    final timeSlots = await _buildTalkTimeSlots(talks, favoritesTalks);

    return PaginatedData(
      items: timeSlots,
    );
  }

  Future<List<TalkTimeSlot>> _buildTalkTimeSlots(
    List<Talk?> talks,
    List<FavoritesTalk?> favorites,
  ) async {
    final talkPreviews = <TalkPreview>[];
    final timeSlots = <TalkTimeSlot>[];
    for (final talk in talks) {
      if (talk == null) continue;
      final speakerTalks = await _dataSource.getSpeakerTalks(talk: talk);
      final talkPreview = TalkPreview(
        id: talk.id,
        title: talk.title ?? '',
        room: talk.room ?? '',
        startTime: talk.startTime?.getDateTimeInUtc() ?? DateTime(2024),
        speakerNames:
            speakerTalks.items.map((st) => st?.speaker?.name ?? '').toList(),
        isFavorite: favorites.any((ft) => ft?.talk == talk),
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
    var favorites = await _dataSource.createFavorites(
      userId: userId,
    );

    final favoritesTalksResponse =
        await _dataSource.getFavoritesTalks(favoritesId: favorites.id);

    final favoritesTalks = favoritesTalksResponse.items
        .where((ft) => ft != null)
        .map((ft) => ft!)
        .toList();

    favorites = favorites.copyWith(talks: favoritesTalks);

    await _cache.set(
      favoritesCacheKey(userId),
      jsonEncode(favorites.toJson()),
    );

    return favorites;
  }

  Future<T> _tryGetFromCache<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    required Future<T> Function() orElse,
  }) async {
    final cached = await _cache.get(key);
    if (cached != null) {
      return fromJson(jsonDecode(cached) as Map<String, dynamic>);
    }
    return orElse();
  }

  Favorites _favoritesFromJson(Map<String, dynamic> json) {
    return Favorites(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      talks: (json['talks'] as List?)
          ?.map((e) => FavoritesTalk.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
