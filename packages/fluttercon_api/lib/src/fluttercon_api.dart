import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:http/http.dart';

/// Generic type representing a JSON factory.
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// Enum representing the HTTP methods used in the API.
enum HttpMethod {
  /// GET method.
  get,

  /// POST method.
  post,

  /// PUT method.
  put,

  /// DELETE method.
  delete,

  /// PATCH method.
  patch,
}

/// {@template fluttercon_api}
/// A Dart API to manage making calls to the Fluttercon backend.
/// {@endtemplate}
class FlutterconApi {
  /// {@macro fluttercon_api}
  FlutterconApi({
    required String baseUrl,
    BaseApiClient? client,
  })  : _baseUrl = baseUrl,
        _client = client ??
            BaseApiClient(
              innerClient: Client(),
            );

  final BaseApiClient _client;
  final String _baseUrl;
  User? _currentUser;

  /// Sets the session token to authenticate with the API.
  Future<void> setToken() async {
    _currentUser ??= await getUser();
    _client.token = _currentUser?.sessionToken;
  }

  /// GET /user
  /// Fetches the current user.
  Future<User> getUser() async {
    _currentUser ??= await _sendRequest<User>(
      uri: Uri.parse('$_baseUrl/user'),
      method: HttpMethod.get,
      fromJson: User.fromJson,
    );
    return _currentUser!;
  }

  /// GET /speakers
  /// Fetches a paginated list of speakers.
  Future<PaginatedData<SpeakerPreview>> getSpeakers() async => _sendRequest(
        uri: Uri.parse('$_baseUrl/speakers'),
        method: HttpMethod.get,
        fromJson: (json) => PaginatedData.fromJson(
          json,
          // ignoring line length to fix coverage gap
          // ignore: lines_longer_than_80_chars
          (item) =>
              SpeakerPreview.fromJson((item ?? {}) as Map<String, dynamic>),
        ),
      );

  /// GET /talks/:userId
  /// Fetches a paginated list of talks.
  /// If not already present, fetches the current user
  /// in order to return the user's favorites.
  Future<PaginatedData<TalkTimeSlot>> getTalks() async {
    _currentUser ??= await getUser();

    return _sendRequest(
      uri: Uri.parse('$_baseUrl/talks/${_currentUser?.id}'),
      method: HttpMethod.get,
      fromJson: (json) => PaginatedData.fromJson(
        json,
        (item) => TalkTimeSlot.fromJson((item ?? {}) as Map<String, dynamic>),
      ),
    );
  }

  /// POST /favorites/
  /// Adds a talk to the current user's favorites.
  Future<CreateFavoriteResponse> addFavorite({
    required CreateFavoriteRequest request,
  }) async {
    return _sendRequest(
      uri: Uri.parse('$_baseUrl/favorites'),
      method: HttpMethod.post,
      fromJson: CreateFavoriteResponse.fromJson,
      body: request,
    );
  }

  /// DELETE /favorites/:userId/:talkId
  /// Removes a talk from the current user's favorites.
  Future<DeleteFavoriteResponse> removeFavorite({
    required DeleteFavoriteRequest request,
  }) async {
    return _sendRequest(
      uri: Uri.parse('$_baseUrl/favorites'),
      method: HttpMethod.delete,
      fromJson: DeleteFavoriteResponse.fromJson,
      body: request,
    );
  }

  /// GET /favorites/:userId
  /// Fetches a paginated list of talks for a given [userId].
  Future<PaginatedData<TalkTimeSlot>> getFavorites({
    required String userId,
  }) async =>
      _sendRequest(
        uri: Uri.parse('$_baseUrl/favorites/$userId'),
        method: HttpMethod.get,
        fromJson: (json) => PaginatedData.fromJson(
          json,
          (item) => TalkTimeSlot.fromJson((item ?? {}) as Map<String, dynamic>),
        ),
      );

  Future<T> _sendRequest<T>({
    required Uri uri,
    required HttpMethod method,
    required FromJson<T> fromJson,
    Object? body,
  }) async {
    try {
      final request = Request(method.name.toUpperCase(), uri);

      if (body != null) {
        request.bodyBytes = utf8.encode(jsonEncode(body));
      }

      final responseStream = await _client.send(request);
      final response = await Response.fromStream(responseStream);
      final responseBody = response.json;

      if (response.statusCode >= 400) {
        throw FlutterconApiClientException(
          statusCode: response.statusCode,
          error: responseBody,
        );
      }

      return fromJson(responseBody);
    } on FlutterconApiMalformedResponseException {
      rethrow;
    } on FlutterconApiClientException {
      rethrow;
    } catch (e) {
      if (e is FlutterconApiClientException) {
        rethrow;
      } else {
        throw FlutterconApiClientException(
          statusCode: HttpStatus.internalServerError,
          error: e,
        );
      }
    }
  }
}

extension on Response {
  Map<String, dynamic> get json {
    try {
      final decodedBody = utf8.decode(bodyBytes);
      return jsonDecode(decodedBody) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FlutterconApiMalformedResponseException(error: error),
        stackTrace,
      );
    }
  }
}
