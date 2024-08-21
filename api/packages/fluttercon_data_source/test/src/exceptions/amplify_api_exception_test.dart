import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('AmplifyApiException', () {
    group('toString', () {
      test(
          'concatenates messages and paths '
          'when exception is ${List<GraphQLResponseError>}', () {
        const errors = [
          GraphQLResponseError(message: 'Error 1', path: ['path1']),
          GraphQLResponseError(message: 'Error 2', path: ['path2']),
        ];

        const exception = AmplifyApiException(exception: errors);

        expect(
          exception.toString(),
          equals(
            'AmplifyApiException: GraphQL Errors: MESSAGE: Error 1, '
            'PATH: [path1], MESSAGE: Error 2, PATH: [path2]',
          ),
        );
      });

      test('returns stringified exception in all other cases', () {
        const exception = AmplifyApiException(exception: 'Error message');

        expect(
          exception.toString(),
          equals('AmplifyApiException: Error message'),
        );
      });
    });
  });
}
