import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestData {
  static const user = User(id: 'id', sessionToken: 'sessionToken');

  static final talkTimeSlotData = PaginatedData(
    items: [
      TalkTimeSlot(
        startTime: DateTime(2024),
        talks: [
          TalkPreview(
            id: '1',
            title: 'Talk 1',
            room: 'Room 1',
            startTime: DateTime(2024),
            speakerNames: const [
              'Speaker 1',
            ],
          ),
          TalkPreview(
            id: '2',
            title: 'Talk 2',
            room: 'Room 2',
            startTime: DateTime(2024),
            speakerNames: const [
              'Speaker 2',
            ],
          ),
          TalkPreview(
            id: '3',
            title: 'Talk 3',
            room: 'Room 3',
            startTime: DateTime(2024),
            speakerNames: const [
              'Speaker 3',
            ],
          ),
        ],
      ),
    ],
  );

  static final error = Exception('oops');
}
