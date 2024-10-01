import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static const userId = 'userId';
  static const favoritesId = 'favoritesId';
  static final talkDateTimeTemporal = TemporalDateTime(DateTime(2024));
  static final talkDateTime = talkDateTimeTemporal.getDateTimeInUtc();

  static final speakers = PaginatedResult(
    [
      Speaker(
        id: '1',
        name: 'John Doe',
        title: 'Test Title 1',
        imageUrl: 'Test Image Url 1',
        bio: 'Sample bio',
      ),
      Speaker(
        id: '2',
        name: 'Jane Doe',
        title: 'Test Title 2',
        imageUrl: 'Test Image Url 2',
        bio: 'Sample bio',
      ),
      Speaker(
        id: '3',
        name: 'John Smith',
        title: 'Test Title 3',
        imageUrl: 'Test Image Url 3',
        bio: 'Sample bio',
      ),
    ],
    null,
    null,
    null,
    Speaker.classType,
    null,
  );

  static const speakerPreviews = PaginatedData(
    items: [
      SpeakerPreview(
        id: '2',
        name: 'Jane Doe',
        title: 'Test Title 2',
        imageUrl: 'Test Image Url 2',
      ),
      SpeakerPreview(
        id: '1',
        name: 'John Doe',
        title: 'Test Title 1',
        imageUrl: 'Test Image Url 1',
      ),
      SpeakerPreview(
        id: '3',
        name: 'John Smith',
        title: 'Test Title 3',
        imageUrl: 'Test Image Url 3',
      ),
    ],
  );

  static const speakerPreviewsJson = {
    'items': [
      {
        'id': '2',
        'name': 'Jane Doe',
        'title': 'Test Title 2',
        'imageUrl': 'Test Image Url 2',
      },
      {
        'id': '1',
        'name': 'John Doe',
        'title': 'Test Title 1',
        'imageUrl': 'Test Image Url 1',
      },
      {
        'id': '3',
        'name': 'John Smith',
        'title': 'Test Title 3',
        'imageUrl': 'Test Image Url 3',
      },
    ],
  };

  static final speakerDetail = SpeakerDetail(
    id: '1',
    name: 'John Doe',
    title: 'Test Title 1',
    imageUrl: 'Test Image Url 1',
    bio: 'Sample bio',
    links: const [
      SpeakerLink(
        id: '1',
        url: 'https://test.com',
        type: SpeakerLinkType.other,
      ),
    ],
    talks: [
      TalkPreview(
        id: '1',
        title: 'Test Talk',
        room: 'Test Room',
        startTime: talkDateTime,
        speakerNames: const ['John Doe'],
        isFavorite: true,
      ),
    ],
  );

  static final speakerDetailJson = {
    'id': '1',
    'name': 'John Doe',
    'title': 'Test Title 1',
    'imageUrl': 'Test Image Url 1',
    'bio': 'Sample bio',
    'links': [
      {
        'id': '1',
        'speaker': {
          'id': '1',
          'name': 'John Doe',
          'title': 'Test Title 1',
          'imageUrl': 'Test Image Url 1',
        },
        'url': 'https://test.com',
        'type': 'other',
      }
    ],
    'talks': [
      {
        'id': '1',
        'title': 'Test Talk',
        'room': 'Test Room',
        'startTime': talkDateTime.toIso8601String(),
        'speakerNames': ['John Doe'],
        'isFavorite': true,
      },
    ],
  };

  static final links = PaginatedResult(
    [
      Link(
        id: '1',
        speaker: speakers.items[0],
        url: 'https://test.com',
        type: LinkType.other,
      ),
    ],
    null,
    null,
    null,
    Link.classType,
    null,
  );

  static final talk = Talk(
    id: '1',
    title: 'Test Talk',
    room: 'Test Room',
    startTime: talkDateTimeTemporal,
  );

  static final talks = PaginatedResult(
    [
      SpeakerTalk(
        speaker: speakers.items[0],
        talk: talk,
      ),
    ],
    null,
    null,
    null,
    SpeakerTalk.classType,
    null,
  );

  static final favorites = Favorites(
    id: favoritesId,
    userId: userId,
    talks: [
      FavoritesTalk(
        id: '1',
        talk: talk,
      ),
    ],
  );

  static final favoritesJson = {
    'id': favoritesId,
    'userId': userId,
    'talks': [
      {
        'id': '1',
        'talk': {
          'id': '1',
          'title': 'Test Talk',
          'room': 'Test Room',
          'startTime': talkDateTime.toIso8601String(),
        },
      },
    ],
  };

  static final favoritesResult = PaginatedResult(
    [favorites],
    null,
    null,
    null,
    Favorites.classType,
    null,
  );
}
