import 'dart:io';

import 'package:http/http.dart';

/// {@template recipes_api_client}
/// An implementation of the base http client
/// of the pub package http. Used to
/// set request headers with the correct data.
/// {@endtemplate}
class BaseApiClient extends BaseClient {
  /// {@macro recipes_api_client}
  BaseApiClient({
    required Client innerClient,
  }) : _innerClient = innerClient;

  final Client _innerClient;

  String? _token;

  /// The bearer token to authenticate API requests.
  String? get token => _token;

  set token(String? token) {
    _token = token;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers.putIfAbsent(
      HttpHeaders.contentTypeHeader,
      () => ContentType.json.value,
    );
    request.headers.putIfAbsent(
      HttpHeaders.acceptHeader,
      () => ContentType.json.value,
    );

    if (_token != null) {
      request.headers.putIfAbsent(
        HttpHeaders.authorizationHeader,
        () => 'Bearer $token',
      );
    }
    return _innerClient.send(request);
  }

  @override
  void close() {
    _innerClient.close();
    super.close();
  }
}
