import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockAPICategory extends Mock implements APICategory {}

class _MockGraphQLRequestWrapper extends Mock
    implements GraphQLRequestWrapper {}

void main() {
  group('AmplifyAPIClient', () {
    late APICategory api;
    late GraphQLRequestWrapper requestWrapper;
    late AmplifyAPIClient client;

    setUpAll(() {
      registerFallbackValue(Speaker.classType);
    });

    setUp(() {
      api = _MockAPICategory();
      requestWrapper = _MockGraphQLRequestWrapper();
      client = AmplifyAPIClient(api: api, requestWrapper: requestWrapper);
    });

    test('can be instantiated', () {
      expect(client, isNotNull);
    });

    group('list', () {
      test('returns a GraphQLRequest with the given type', () {
        GraphQLRequest<PaginatedResult<T>> listFunc<T extends Model>(
          ModelType<T> modelType, {
          int? limit,
          QueryPredicate? where,
          String? apiName,
          APIAuthorizationType? authorizationMode,
          Map<String, String>? headers,
        }) {
          return GraphQLRequest<PaginatedResult<T>>(document: '');
        }

        when(() => requestWrapper.list).thenReturn(listFunc);
        expect(
          client.list(Speaker.classType),
          isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
        );
      });
    });

    group('query', () {
      test('calls api query', () {
        final request = GraphQLRequest<PaginatedResult<Speaker>>(document: '');
        when(() => api.query(request: request)).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.speaker, Speaker.classType),
          ),
        );

        client.query(request: request);
        verify(() => api.query(request: request)).called(1);
      });
    });
  });
}
