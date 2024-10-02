import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static const userResponse = {'id': 'id', 'sessionToken': 'sessionToken'};

  static final talksResponse = {
    'items': [
      {
        'startTime': '2024-01-01T00:00:00.000Z',
        'talks': [
          {
            'id': 'id',
            'title': 'title',
            'room': 'room',
            'startTime': '2024-01-01T00:00:00.000Z',
            'speakerNames': <String>[],
            'isFavorite': true,
          },
        ],
      },
    ],
  };

  static final speakersResponse = {
    'items': [
      {
        'id': 'id',
        'name': 'name',
        'title': 'title',
        'imageUrl': 'imageUrl',
      },
    ],
  };

  static const userId = 'userId';
  static const talkId = 'talkId';

  static final talkDetailResponse = {
    'id': talkId,
    'title': 'title',
    'room': 'room',
    'startTime': '2024-01-01T00:00:00.000Z',
    'speakers': [
      {
        'id': 'id',
        'name': 'name',
        'title': 'title',
        'imageUrl': 'imageUrl',
      },
    ],
    'description': 'description',
  };

  static final speakerDetailResponse = {
    'id': 'id',
    'name': 'name',
    'title': 'title',
    'imageUrl': 'imageUrl',
    'bio': 'bio',
    'links': <SpeakerLink>[],
    'talks': <TalkPreview>[],
  };

  static const createFavoriteRequest = CreateFavoriteRequest(
    userId: userId,
    talkId: talkId,
  );

  static final createFavoriteResponse = {
    'userId': userId,
    'talkId': talkId,
  };

  static const deleteFavoriteRequest = DeleteFavoriteRequest(
    userId: userId,
    talkId: talkId,
  );

  static final deleteFavoriteResponse = {
    'userId': userId,
    'talkId': talkId,
  };
}
