import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestData {
  static const user = User(id: 'userId', sessionToken: 'sessionToken');

  static PaginatedData<TalkTimeSlot> talkTimeSlotData({
    bool favorites = false,
  }) =>
      PaginatedData(
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
                isFavorite: favorites,
              ),
              TalkPreview(
                id: '2',
                title: 'Talk 2',
                room: 'Room 2',
                startTime: DateTime(2024),
                speakerNames: const [
                  'Speaker 2',
                ],
                isFavorite: favorites,
              ),
              TalkPreview(
                id: '3',
                title: 'Talk 3',
                room: 'Room 3',
                startTime: DateTime(2024),
                speakerNames: const [
                  'Speaker 3',
                ],
                isFavorite: favorites,
              ),
            ],
          ),
        ],
      );

  static final favoriteIds = talkTimeSlotData(favorites: true)
      .items
      .expand((timeSlot) => timeSlot.talks)
      .where((talk) => talk.isFavorite)
      .map((talk) => talk.id)
      .toList();

  static const speakerData = PaginatedData(
    items: [
      SpeakerPreview(
        id: '1',
        name: 'Speaker 1',
        title: 'Title 1',
        imageUrl: 'Image 1',
      ),
      SpeakerPreview(
        id: '2',
        name: 'Speaker 2',
        title: 'Title 2',
        imageUrl: 'Image 2',
      ),
      SpeakerPreview(
        id: '3',
        name: 'Speaker 3',
        title: 'Title 3',
        imageUrl: 'Image 3',
      ),
    ],
  );

  static final error = Exception('oops');

  static final talkDetail = TalkDetail(
    id: 'talkId',
    title: 'title',
    room: 'room',
    startTime: DateTime(2024),
    speakers: const [
      SpeakerPreview(
        id: 'speakerId',
        name: 'Speaker',
        title: 'Title',
        imageUrl: 'imageUrl',
      ),
    ],
    description: '',
  );
}
