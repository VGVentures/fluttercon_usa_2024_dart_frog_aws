import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';

class TestHelpers {
  static const paginatedData = PaginatedData(
    items: [1, 2, 3],
    limit: 3,
    nextToken: 'token',
  );

  static const paginatedDataJson = {
    'items': [1, 2, 3],
    'limit': 3,
    'nextToken': 'token',
  };

  static const speakerDetail = SpeakerDetail(
    id: '1',
    name: 'John Doe',
    title: 'Speaker',
    bio: 'A person',
    imageUrl: 'https://example.com',
    links: [],
    talks: [],
  );

  static const speakerDetailJson = {
    'id': '1',
    'name': 'John Doe',
    'title': 'Speaker',
    'bio': 'A person',
    'imageUrl': 'https://example.com',
    'links': <String>[],
    'talks': <String>[],
  };

  static const speakerLink = SpeakerLink(
    id: '1',
    url: 'https://example.com',
    type: SpeakerLinkType.other,
  );

  static const speakerLinkJson = {
    'id': '1',
    'url': 'https://example.com',
    'type': 'other',
    'description': null,
  };

  static const speakerPreview = SpeakerPreview(
    id: '1',
    name: 'John Doe',
    title: 'Speaker',
    imageUrl: 'https://example.com',
  );

  static const speakerPreviewJson = {
    'id': '1',
    'name': 'John Doe',
    'title': 'Speaker',
    'imageUrl': 'https://example.com',
  };

  static final talkDetail = TalkDetail(
    id: '1',
    title: 'title',
    description: 'description',
    room: 'room',
    speakers: const [],
    startTime: DateTime(2024),
  );

  static final talkDetailJson = {
    'id': '1',
    'title': 'title',
    'description': 'description',
    'room': 'room',
    'speakers': <String>[],
    'startTime': '2024-01-01T00:00:00.000',
  };

  static final talkPreview = TalkPreview(
    id: '1',
    title: 'title',
    room: 'room',
    speakerNames: const [],
    startTime: DateTime(2024),
  );

  static final talkPreviewJson = {
    'id': '1',
    'title': 'title',
    'room': 'room',
    'speakerNames': <String>[],
    'startTime': '2024-01-01T00:00:00.000',
  };

  static final talkTimeSlot = TalkTimeSlot(
    startTime: DateTime(2024),
    talks: [talkPreview],
  );

  static final talkTimeSlotJson = {
    'startTime': '2024-01-01T00:00:00.000',
    'talks': [talkPreviewJson],
  };
}
