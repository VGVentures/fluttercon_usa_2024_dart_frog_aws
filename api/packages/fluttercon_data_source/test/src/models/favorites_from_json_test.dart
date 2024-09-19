import 'package:fluttercon_data_source/src/models/favorites_from_json.dart';
import 'package:test/test.dart';

void main() {
  group('favoritesFromJson', () {
    test('can de-serialize talks from json', () {
      final json = {
        'id': '1',
        'userId': '1',
        'talks': [
          {
            'id': '1',
            'talk': {
              'id': '1',
              'title': 'Talk title',
              'description': 'Talk description',
              'isFavorite': false,
            },
          },
        ],
      };

      final favorites = favoritesFromJson(json);

      expect(favorites.talks, hasLength(1));
    });
  });
}
