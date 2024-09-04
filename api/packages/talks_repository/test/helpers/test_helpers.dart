import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static final talk1StartTime = TemporalDateTime(DateTime(2024, 1, 3));
  static final talk2StartTime = TemporalDateTime(DateTime(2024, 1, 2));
  static final talk3StartTime = TemporalDateTime(DateTime(2024));

  static final talks = PaginatedResult(
    [
      Talk(
        id: '1',
        title: 'Test Talk 1',
        room: 'Room 1',
        startTime: talk1StartTime,
      ),
      Talk(
        id: '2',
        title: 'Test Talk 2',
        room: 'Room 2',
        startTime: talk2StartTime,
      ),
      Talk(
        id: '3',
        title: 'Test Talk 3',
        room: 'Room 3',
        startTime: talk3StartTime,
      ),
    ],
    null,
    null,
    null,
    Talk.classType,
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
        startTime: talk3StartTime.getDateTimeInUtc(),
        talks: [
          TalkPreview(
            id: '3',
            title: 'Test Talk 3',
            room: 'Room 3',
            startTime: talk3StartTime.getDateTimeInUtc(),
            speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          ),
        ],
      ),
      TalkTimeSlot(
        startTime: talk2StartTime.getDateTimeInUtc(),
        talks: [
          TalkPreview(
            id: '2',
            title: 'Test Talk 2',
            room: 'Room 2',
            startTime: talk2StartTime.getDateTimeInUtc(),
            speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          ),
        ],
      ),
      TalkTimeSlot(
        startTime: talk1StartTime.getDateTimeInUtc(),
        talks: [
          TalkPreview(
            id: '1',
            title: 'Test Talk 1',
            room: 'Room 1',
            startTime: talk1StartTime.getDateTimeInUtc(),
            speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          ),
        ],
      ),
    ],
  );

  static final talkTimeSlotsJson = {
    'items': [
      {
        'startTime': '2024-01-01T05:00:00.000Z',
        'talks': [
          {
            'id': '3',
            'title': 'Test Talk 3',
            'room': 'Room 3',
            'startTime': '2024-01-01T05:00:00.000Z',
            'speakerNames': ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          },
        ],
      },
      {
        'startTime': '2024-01-02T05:00:00.000Z',
        'talks': [
          {
            'id': '2',
            'title': 'Test Talk 2',
            'room': 'Room 2',
            'startTime': '2024-01-02T05:00:00.000Z',
            'speakerNames': ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          },
        ],
      },
      {
        'startTime': '2024-01-03T05:00:00.000Z',
        'talks': [
          {
            'id': '1',
            'title': 'Test Talk 1',
            'room': 'Room 1',
            'startTime': '2024-01-03T05:00:00.000Z',
            'speakerNames': ['Speaker 1', 'Speaker 2', 'Speaker 3'],
          },
        ],
      },
    ],
  };
}
