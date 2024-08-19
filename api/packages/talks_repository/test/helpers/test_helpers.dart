import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static final talks = PaginatedResult(
    [
      Talk(
        id: '1',
        title: 'Test Talk 1',
        room: 'Room 1',
      ),
      Talk(
        id: '2',
        title: 'Test Talk 2',
        room: 'Room 2',
      ),
      Talk(
        id: '3',
        title: 'Test Talk 3',
        room: 'Room 3',
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

  static final talkPreviews = PaginatedData(
    items: [
      TalkPreview(
        id: '1',
        title: 'Test Talk 1',
        room: 'Room 1',
        startTime: DateTime(2024),
        speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
      ),
      TalkPreview(
        id: '2',
        title: 'Test Talk 2',
        room: 'Room 2',
        startTime: DateTime(2024),
        speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
      ),
      TalkPreview(
        id: '3',
        title: 'Test Talk 3',
        room: 'Room 3',
        startTime: DateTime(2024),
        speakerNames: const ['Speaker 1', 'Speaker 2', 'Speaker 3'],
      ),
    ],
  );
}
