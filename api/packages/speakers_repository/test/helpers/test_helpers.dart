import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static const userId = 'userId';

  static final speakers = PaginatedResult(
    [
      Speaker(
        id: '1',
        name: 'John Doe',
        title: 'Test Title 1',
        imageUrl: 'Test Image Url 1',
      ),
      Speaker(
        id: '2',
        name: 'Jane Doe',
        title: 'Test Title 2',
        imageUrl: 'Test Image Url 2',
      ),
      Speaker(
        id: '3',
        name: 'John Smith',
        title: 'Test Title 3',
        imageUrl: 'Test Image Url 3',
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

  static const speakerDetail = SpeakerDetail(
    id: '1',
    name: 'John Doe',
    title: 'Test Title 1',
    imageUrl: 'Test Image Url 1',
    bio: 'Sample bio',
    links: [],
    talks: [],
  );

  static final links = PaginatedResult(
    [
      Link(
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
    id: 'favoritesId',
    userId: userId,
    talks: [
      FavoritesTalk(
        talk: talk,
      ),
    ],
  );
}
