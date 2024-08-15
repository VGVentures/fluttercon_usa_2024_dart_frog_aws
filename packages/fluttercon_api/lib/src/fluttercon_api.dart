import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:http/http.dart';
import 'package:user_repository/user_repository.dart';

/// Signature for the authentication token provider.
typedef TokenProvider = Future<String?> Function();

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
    Client? client,
  })  : _baseUrl = baseUrl,
        _client = client ??
            BaseApiClient(
              innerClient: Client(),
            );

  final Client _client;
  final String _baseUrl;
  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<User> getCurrentUser() async {
    final user = await _sendRequest<User>(
      uri: Uri.parse('$_baseUrl/user'),
      method: HttpMethod.get,
      fromJson: User.fromJson,
    );

    return _currentUser ??= await _sendRequest<User>(
      uri: Uri.parse('$_baseUrl/user'),
      method: HttpMethod.get,
      fromJson: User.fromJson,
    );
  }

  void setSessionToken(String token) {
    (_client as BaseApiClient).token = token;
  }

  Future<T> _sendRequest<T>({
    required Uri uri,
    required HttpMethod method,
    required FromJson<T> fromJson,
    Object? requestBody,
  }) async {
    try {
      final request = Request(method.name.toUpperCase(), uri);

      if (requestBody != null) {
        request.bodyBytes = utf8.encode(jsonEncode(requestBody));
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
      throw FlutterconApiClientException(
        statusCode: HttpStatus.internalServerError,
        error: e,
      );
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
