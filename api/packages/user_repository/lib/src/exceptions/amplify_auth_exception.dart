/// {@template Exceptions}
/// Exception thrown when an error occurs
/// while interacting with the Amplify Auth.
/// {@endtemplate}
class AmplifyAuthException implements Exception {
  /// {@macro Exceptions}
  const AmplifyAuthException({required this.exception});

  /// The exception that caused the error.
  final Object exception;
}
