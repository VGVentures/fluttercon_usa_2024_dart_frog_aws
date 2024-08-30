import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

/// {@template talks_repository}
/// A repository to cache and prepare talk data retrieved from the api.
/// {@endtemplate}
class TalksRepository {
  /// {@macro talks_repository}
  const TalksRepository({
    required FlutterconDataSource dataSource,
  }) : _dataSource = dataSource;

  final FlutterconDataSource _dataSource;

  /// Fetches a paginated list of talks from the data source.
  /// Returns [TalkTimeSlot] objects with speaker information
  /// for each one.
  Future<PaginatedData<TalkTimeSlot>> getTalks() async {
    final timeSlots = <TalkTimeSlot>[];
    final talks = <TalkPreview>[];

    final talksResponse = await _dataSource.getTalks();
    for (final talk in talksResponse.items) {
      if (talk == null) continue;
      final speakerTalks = await _dataSource.getSpeakerTalks(talkId: talk);
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

    return PaginatedData(
      items: sortedTimeSlots,
      limit: talksResponse.limit,
      nextToken: talksResponse.nextToken,
    );
  }
}
