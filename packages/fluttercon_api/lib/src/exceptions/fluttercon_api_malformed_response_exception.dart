/// {@template fluttercon_api_malformed_response_exception}
/// An exception thrown when the API response is malformed.
/// {@endtemplate}
class FlutterconApiMalformedResponseException implements Exception {
  /// {@macro fluttercon_api_malformed_response_exception}
  const FlutterconApiMalformedResponseException({
    required this.error,
  });

  /// The error object returned from the API.
  final Object error;
}
