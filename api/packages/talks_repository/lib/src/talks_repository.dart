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

    final timeSlots = <TalkTimeSlot>[];
    final talks = <TalkPreview>[];

    final talksResponse = await _dataSource.getTalks();
    for (final talk in talksResponse.items) {
      if (talk == null) continue;
      final speakerTalks = await _dataSource.getSpeakerTalks(talk: talk);
      final talkPreview = TalkPreview(
        id: talk.id,
        title: talk.title ?? '',
        room: talk.room ?? '',
        startTime: talk.startTime?.getDateTimeInUtc() ?? DateTime(2024),
        speakerNames:
            speakerTalks.items.map((st) => st?.speaker?.name ?? '').toList(),
      );
      talks.add(talkPreview);
    }
    final times = talks.map((t) => t.startTime).toSet();

    for (final time in times) {
      final talksForTime = talks.where((t) => t.startTime == time).toList();
      final timeSlot = TalkTimeSlot(
        startTime: time,
        talks: talksForTime,
      );
      timeSlots.add(timeSlot);
    }

    final sortedTimeSlots = [...timeSlots]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final result = PaginatedData(
      items: sortedTimeSlots,
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
}
