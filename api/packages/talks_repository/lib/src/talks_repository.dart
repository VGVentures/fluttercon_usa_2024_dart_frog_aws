import 'dart:convert';

import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

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
    final favorites = await tryGetFromCache(
      getFromCache: () => _cache.get(favoritesCacheKey(request.userId)),
      fromJson: favoritesFromJson,
      orElse: () async => getFavoritesFromApi(request.userId),
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
    final favorites = await tryGetFromCache(
      getFromCache: () => _cache.get(favoritesCacheKey(request.userId)),
      fromJson: favoritesFromJson,
      orElse: () async => getFavoritesFromApi(request.userId),
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
    final talkData = await tryGetFromCache(
      getFromCache: () => _cache.get(talksCacheKey),
      fromJson: (json) => PaginatedData.fromJson(
        json,
        (val) => Talk.fromJson((val ?? {}) as Map<String, dynamic>),
      ),
      orElse: getTalksFromApi,
    );

    final speakerData = await tryGetFromCache(
      getFromCache: () => _cache.get(
        speakerTalksCacheKey(
          talkData.items.map((t) => t?.id).join(','),
        ),
      ),
      fromJson: (json) => PaginatedData.fromJson(
        json,
        (val) => SpeakerTalk.fromJson((val ?? {}) as Map<String, dynamic>),
      ),
      orElse: () => getSpeakersFromApi(talkData.items),
    );

    final favorites = await tryGetFromCache(
      getFromCache: () => _cache.get(favoritesCacheKey(userId)),
      fromJson: favoritesFromJson,
      orElse: () async => getFavoritesFromApi(userId),
    );

    final timeSlots = await _buildTalkTimeSlots(
      talks: talkData.items,
      speakers: speakerData.items,
      favorites: favorites.talks ?? [],
    );

    return PaginatedData(
      items: timeSlots,
      limit: talkData.limit,
      nextToken: talkData.nextToken,
    );
  }

  /// Fetches a [TalkDetail] entity by [id].
  Future<TalkDetail> getTalk({required String id}) async => tryGetFromCache(
        getFromCache: () => _cache.get(talkCacheKey(id)),
        fromJson: TalkDetail.fromJson,
        orElse: () => getTalkDetailFromApi(id),
      );

  /// Fetches a paginated list of talks for a given [userId].
  ///
  ///  Returns [TalkTimeSlot] objects with speaker information
  /// for each one.
  Future<PaginatedData<TalkTimeSlot>> getFavorites({
    required String userId,
  }) async {
    final favorites = await tryGetFromCache(
      getFromCache: () => _cache.get(favoritesCacheKey(userId)),
      fromJson: favoritesFromJson,
      orElse: () async => getFavoritesFromApi(userId),
    );

    final favoritesTalks = favorites.talks ?? [];

    final talks = favoritesTalks
        .where((ft) => ft.talk != null)
        .map((ft) => ft.talk!)
        .toList();

    final speakerData = await tryGetFromCache(
      getFromCache: () => _cache.get(
        speakerTalksCacheKey(
          talks.map((t) => t.id).join(','),
        ),
      ),
      fromJson: (json) => PaginatedData.fromJson(
        json,
        (val) => SpeakerTalk.fromJson((val ?? {}) as Map<String, dynamic>),
      ),
      orElse: () => getSpeakersFromApi(talks),
    );

    final timeSlots = await _buildTalkTimeSlots(
      talks: talks,
      speakers: speakerData.items,
      favorites: favoritesTalks,
    );

    return PaginatedData(
      items: timeSlots,
    );
  }

  Future<List<TalkTimeSlot>> _buildTalkTimeSlots({
    required List<Talk?> talks,
    required List<SpeakerTalk?> speakers,
    required List<FavoritesTalk?> favorites,
  }) async {
    final talkPreviews = <TalkPreview>[];
    final timeSlots = <TalkTimeSlot>[];
    for (final talk in talks) {
      if (talk == null) continue;
      final speakersForTalk =
          speakers.where((st) => st?.talk?.id == talk.id).toList();
      final talkPreview = TalkPreview(
        id: talk.id,
        title: talk.title ?? '',
        room: talk.room ?? '',
        startTime: talk.startTime?.getDateTimeInUtc() ?? DateTime(2024),
        speakerNames:
            speakersForTalk.map((st) => st?.speaker?.name ?? '').toList(),
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

  /// Fetch [Favorites] from the api.
  Future<Favorites> getFavoritesFromApi(String userId) async {
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

  /// Get [SpeakerTalk] entities from the api.
  /// For internal use inside [TalksRepository].
  Future<PaginatedData<SpeakerTalk?>> getSpeakersFromApi(
    List<Talk?> talks,
  ) async {
    final response = await _dataSource.getSpeakerTalks(
      talks: talks,
    );
    final data = PaginatedData(
      items: response.items,
      limit: response.limit,
      nextToken: response.nextToken,
    );
    await _cache.set(
      speakerTalksCacheKey(
        talks.map((t) => t?.id).join(','),
      ),
      jsonEncode(
        data.toJson(
          (val) => val?.toJson(),
        ),
      ),
    );
    return data;
  }

  /// Get [Talk] entities from the api.
  /// For internal use inside [TalksRepository].
  Future<PaginatedData<Talk?>> getTalksFromApi() async {
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
  }

  /// Get a [TalkDetail] entity from the api.
  /// For internal use inside [TalksRepository].
  Future<TalkDetail> getTalkDetailFromApi(String id) async {
    final talk = await _dataSource.getTalk(id: id);
    final speakerTalks = await _dataSource.getSpeakerTalks(
      talks: [talk],
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
  }
}
