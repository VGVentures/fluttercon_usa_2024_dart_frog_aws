/// {@template fluttercon_api_client_exception}
/// An exception thrown when an error occurs fetching API data.
/// {@endtemplate}
class FlutterconApiClientException implements Exception {
  /// {@macro fluttercon_api_client_exception}
  const FlutterconApiClientException({
    required this.statusCode,
    required this.error,
  });

  /// The status code of the response.
  final int statusCode;

  /// The error object returned from the API.
  final Object error;
}
