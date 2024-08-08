/// {@template Exceptions}
/// Exception thrown when an error occurs
/// while interacting with the Amplify API.
/// {@endtemplate}
class AmplifyApiException implements Exception {
  /// {@macro Exceptions}
  const AmplifyApiException({required this.exception});

  /// The exception that caused the error.
  final Object exception;
}
