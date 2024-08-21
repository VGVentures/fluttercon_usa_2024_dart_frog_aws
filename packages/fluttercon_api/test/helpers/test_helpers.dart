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
          },
        ],
      },
    ],
  };
}
