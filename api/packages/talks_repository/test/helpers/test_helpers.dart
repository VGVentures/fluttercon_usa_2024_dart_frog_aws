import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static final talk1StartTimeTemporal = TemporalDateTime(DateTime(2024, 1, 3));
  static final talk2StartTimeTemporal = TemporalDateTime(DateTime(2024, 1, 2));
  static final talk3StartTimeTemporal = TemporalDateTime(DateTime(2024));

  static final talk1StartTime = talk1StartTimeTemporal.getDateTimeInUtc();
  static final talk2StartTime = talk2StartTimeTemporal.getDateTimeInUtc();
  static final talk3StartTime = talk3StartTimeTemporal.getDateTimeInUtc();

  static const favoritesId = 'favoritesId';
  static const userId = 'userId';

  static final favorites = PaginatedResult(
    [Favorites(id: favoritesId, userId: userId)],
    null,
    null,
    null,
    Favorites.classType,
    null,
  );

  static final favoritesJson = {
    'id': favoritesId,
    'items': [
      {'userId': userId},
    ],
  };

  static final talks = PaginatedResult(
    [
      Talk(
        id: '1',
        title: 'Test Talk 1',
        room: 'Room 1',
        startTime: talk1StartTimeTemporal,
      ),
      Talk(
        id: '2',
        title: 'Test Talk 2',
        room: 'Room 2',
        startTime: talk2StartTimeTemporal,
      ),
      Talk(
        id: '3',
        title: 'Test Talk 3',
        room: 'Room 3',
        startTime: talk3StartTimeTemporal,
      ),
    ],
    null,
    null,
    null,
    Talk.classType,
    null,
  );

  static final createFavoriteRequest = CreateFavoriteRequest(
    userId: userId,
    talkId: talks.items[0]!.id,
  );

  static final createFavoriteResponse = CreateFavoriteResponse(
    userId: userId,
    talkId: talks.items[0]!.id,
  );

  static final deleteFavoriteRequest = DeleteFavoriteRequest(
    userId: userId,
    talkId: talks.items[0]!.id,
  );

  static final deleteFavoriteResponse = DeleteFavoriteResponse(
    userId: userId,
    talkId: talks.items[0]!.id,
  );

  static final favoritesTalks = PaginatedResult(
    [
      FavoritesTalk(
        id: '1',
        favorites: favorites.items[0],
        talk: talks.items[0],
      ),
      FavoritesTalk(
        id: '2',
        favorites: favorites.items[0],
        talk: talks.items[1],
      ),
      FavoritesTalk(
        id: '3',
        favorites: favorites.items[0],
        talk: talks.items[2],
      ),
    ],
    null,
    null,
    null,
    FavoritesTalk.classType,
    null,
  );

  static final favoritesTalkSingle = PaginatedResult(
    [
      FavoritesTalk(
        id: '1',
        favorites: favorites.items[0],
        talk: talks.items[0],
      ),
    ],
    null,
    null,
    null,
    FavoritesTalk.classType,
    null,
  );

  static PaginatedResult<SpeakerTalk> speakerTalks(Talk talk) =>
      PaginatedResult(
        [
          SpeakerTalk(
            id: '1',
            speaker: Speaker(
              id: '1',
              name: 'Speaker 1',
            ),
            talk: talk,
          ),
          SpeakerTalk(
            id: '2',
            speaker: Speaker(
              id: '2',
              name: 'Speaker 2',
            ),
            talk: talk,
          ),
          SpeakerTalk(
            id: '3',
            speaker: Speaker(
              id: '3',
              name: 'Speaker 3',
            ),
            talk: talk,
          ),
        ],
        null,
        null,
        null,
        SpeakerTalk.classType,
        null,
      );

  static final talkTimeSlots = PaginatedData(
    items: [
      TalkTimeSlot(
        startTime: talk3StartTime,
        talks: [
          TalkPreview(
            id: '3',
            title: 'Test Talk 3',
            room: 'Room 3',
            startTime: talk3StartTime,
            speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
            isFavorite: false,
          ),
        ],
      ),
      TalkTimeSlot(
        startTime: talk2StartTime,
        talks: [
          TalkPreview(
            id: '2',
            title: 'Test Talk 2',
            room: 'Room 2',
            startTime: talk2StartTime,
            speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
            isFavorite: false,
          ),
        ],
      ),
      TalkTimeSlot(
        startTime: talk1StartTime,
        talks: [
          TalkPreview(
            id: '1',
            title: 'Test Talk 1',
            room: 'Room 1',
            startTime: talk1StartTime,
            speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
            isFavorite: false,
          ),
        ],
      ),
    ],
  );

  static final talkTimeSlotsJson = {
    'items': [
      {
        'startTime': talk3StartTime.toIso8601String(),
        'talks': [
          {
            'id': '3',
            'title': 'Test Talk 3',
            'room': 'Room 3',
            'startTime': talk3StartTime.toIso8601String(),
            'speakerNames': ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          },
        ],
      },
      {
        'startTime': talk2StartTime.toIso8601String(),
        'talks': [
          {
            'id': '2',
            'title': 'Test Talk 2',
            'room': 'Room 2',
            'startTime': talk2StartTime.toIso8601String(),
            'speakerNames': ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          },
        ],
      },
      {
        'startTime': talk1StartTime.toIso8601String(),
        'talks': [
          {
            'id': '1',
            'title': 'Test Talk 1',
            'room': 'Room 1',
            'startTime': talk1StartTime.toIso8601String(),
            'speakerNames': ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          },
        ],
      },
    ],
  };
}
