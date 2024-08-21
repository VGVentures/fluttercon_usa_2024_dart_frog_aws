import 'package:amplify_core/amplify_core.dart';

/// {@template Exceptions}
/// Exception thrown when an error occurs
/// while interacting with the Amplify API.
/// {@endtemplate}
class AmplifyApiException implements Exception {
  /// {@macro Exceptions}
  const AmplifyApiException({required this.exception});

  /// The exception that caused the error.
  final Object exception;

  @override
  String toString() {
    final sb = StringBuffer()..write('AmplifyApiException: ');
    if (exception is List<GraphQLResponseError>) {
      sb.write('GraphQL Errors: ');
      final errors = exception as List<GraphQLResponseError>;
      sb.writeAll(
        errors.map(
          (e) {
            final message = 'MESSAGE: ${e.message}, PATH: ${e.path}';
            return e == errors.last ? message : '$message, ';
          },
        ),
      );
    } else {
      sb.write(exception);
    }
    return sb.toString();
  }
}
