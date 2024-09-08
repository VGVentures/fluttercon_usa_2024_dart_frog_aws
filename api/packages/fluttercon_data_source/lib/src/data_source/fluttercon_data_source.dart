import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/src/data_source/amplify_api_client.dart';
import 'package:fluttercon_data_source/src/exceptions/exceptions.dart';

import 'package:fluttercon_data_source/src/models/models.dart';

/// Function that takes a [GraphQLRequest]
/// and returns a [GraphQLOperation].
typedef GraphQLOperator<T> = GraphQLOperation<T> Function(GraphQLRequest<T>);

/// {@template fluttercon_data_source}
/// Data access layer for FlutterCon demo app.
/// Uses Amplify API to interact with the backend.
/// {@endtemplate}
class FlutterconDataSource {
  /// {@macro fluttercon_data_source}
  const FlutterconDataSource({required AmplifyAPIClient apiClient})
      : _apiClient = apiClient;

  final AmplifyAPIClient _apiClient;

  /// Creates a new [Favorites] entity.
  Future<Favorites> createFavorites({required String userId}) async {
    try {
      final request = _apiClient.create(Favorites(userId: userId));
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.mutate(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Creates a new [FavoritesTalk] entity.
  Future<FavoritesTalk> createFavoritesTalk({
    required String favoritesId,
    required String talkId,
  }) async {
    try {
      final request = _apiClient.create(
        FavoritesTalk(
          favorites: Favorites(id: favoritesId),
          talk: Talk(id: talkId),
        ),
      );
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.mutate(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a paginated list of [Favorites] entities.
  /// Can optionally provide a [userId] to filter.
  Future<PaginatedResult<Favorites>> getFavorites({String? userId}) async {
    try {
      final request = _apiClient.list(
        Favorites.classType,
        where: userId != null ? Favorites.USERID.eq(userId) : null,
      );

      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a paginated list of speakers.
  Future<PaginatedResult<Speaker>> getSpeakers() async {
    try {
      final request = _apiClient.list(Speaker.classType);
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a paginated list of talks.
  Future<PaginatedResult<Talk>> getTalks({List<String> ids = const []}) async {
    try {
      final request = _apiClient.list(
        Talk.classType,
        where: ids.isNotEmpty
            ? QueryPredicateGroup(QueryPredicateGroupType.or, [
                for (final id in ids) Talk.ID.eq(id),
              ])
            : null,
      );
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a [Talk] entity by [id].
  Future<Talk> getTalk({required String id}) async {
    try {
      final request =
          _apiClient.get(Talk.classType, TalkModelIdentifier(id: id));
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a paginated list of [FavoritesTalk] entities
  /// for a [favoritesId].
  /// A [FavoritesTalk] contains an ID for a favorites entity and
  /// an ID for a corresponding talk.
  Future<PaginatedResult<FavoritesTalk>> getFavoritesTalks({
    required String favoritesId,
  }) async {
    try {
      final request = _apiClient.list(
        FavoritesTalk.classType,
        where: FavoritesTalk.FAVORITES.eq(favoritesId),
      );
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a paginated list of [SpeakerTalk] entities.
  /// A [SpeakerTalk] contains an ID for a speaker and
  /// an ID for a corresponding talk.
  ///
  /// Consumers can optionally provide either a [Speaker]
  /// and/or a [Talk] to filter the results.
  Future<PaginatedResult<SpeakerTalk>> getSpeakerTalks({
    Speaker? speaker,
    Talk? talk,
  }) async {
    assert(speaker == null || talk == null, 'Only one filter can be applied');
    try {
      final queryPredicate = speaker != null
          ? SpeakerTalk.SPEAKER.eq(speaker.id)
          : talk != null
              ? SpeakerTalk.TALK.eq(talk.id)
              : null;
      final request = _apiClient.list(
        SpeakerTalk.classType,
        where: queryPredicate,
      );
      return _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  Future<T> _sendGraphQLRequest<T>({
    required GraphQLRequest<T> request,
    required GraphQLOperator<T> operation,
  }) async {
    final response = await operation(request).response;
    if (response.hasErrors) {
      throw AmplifyApiException(exception: response.errors);
    }
    if (response.data == null) {
      throw AmplifyApiException(
        exception: 'No $T Data Found for Request: $request',
      );
    }
    return response.data!;
  }
}
