import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/src/models/models.dart';

class TestHelpers {
  static final speaker = Speaker(
    id: '1',
    name: 'John Doe',
    bio: 'Speaker bio',
  );

  static final talk = Talk(
    id: '1',
    title: 'Talk title',
    description: 'Talk description',
    isFavorite: false,
  );

  static final favorites = Favorites(
    id: '1',
    userId: '1',
  );

  static final speakerTalk = SpeakerTalk(
    id: '1',
    speaker: speaker,
    talk: talk,
  );

  static final favoritesTalk = FavoritesTalk(
    id: '1',
    favorites: favorites,
    talk: talk,
  );

  static PaginatedResult<T> paginatedResult<T extends Model>(
    T item,
    ModelType<T> modelType,
  ) =>
      PaginatedResult<T>([item], null, null, null, modelType, null);

  static GraphQLOperation<T> graphQLOperation<T extends Model>(
    T? item, {
    List<GraphQLResponseError> errors = const [],
  }) =>
      GraphQLOperation<T>(
        CancelableOperation.fromValue(
          GraphQLResponse(
            data: item,
            errors: errors,
          ),
        ),
      );
}
