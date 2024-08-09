// ignore_for_file: prefer_const_constructors
import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_data_source/src/models/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockAmplifyApiClient extends Mock implements AmplifyAPIClient {}

void main() {
  group('FlutterconDataSource', () {
    late AmplifyAPIClient apiClient;
    late FlutterconDataSource dataSource;

    setUpAll(() {
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<Speaker>>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<Talk>>(document: ''),
      );
    });

    setUp(() async {
      apiClient = _MockAmplifyApiClient();
      dataSource = FlutterconDataSource(apiClient: apiClient);
    });

    test('can be instantiated', () async {
      expect(dataSource, isNotNull);
    });

    group('getSpeakers', () {
      setUp(() {
        when(() => apiClient.list(Speaker.classType)).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Speaker>>(
            document: '',
          ),
        );
      });

      test('returns ${PaginatedResult<Speaker>} when successful', () async {
        when(
          () => apiClient.query<PaginatedResult<Speaker>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.speaker, Speaker.classType),
          ),
        );

        final result = await dataSource.getSpeakers();
        expect(result, isA<PaginatedResult<Speaker>>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<Speaker>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.speaker, Speaker.classType),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getSpeakers(),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<Speaker>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getSpeakers(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.list(Speaker.classType))
              .thenThrow(Exception('Error'));

          expect(
            () => dataSource.getSpeakers(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getTalks', () {
      setUp(() {
        when(() => apiClient.list(Talk.classType)).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Talk>>(
            document: '',
          ),
        );
      });
      test('returns ${PaginatedResult<Talk>} when successful', () async {
        when(
          () => apiClient.query<PaginatedResult<Talk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.talk, Talk.classType),
          ),
        );

        final result = await dataSource.getTalks();
        expect(result, isA<PaginatedResult<Talk>>());
      });

      test(
          'returns filtered ${PaginatedResult<Talk>} when successful '
          'and [favorites] is true', () async {
        when(
          () => apiClient.list(
            Talk.classType,
            where: any(named: 'where'),
          ),
        ).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Talk>>(
            document: '',
          ),
        );
        when(
          () => apiClient.query<PaginatedResult<Talk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.favoriteTalk,
              Talk.classType,
            ),
          ),
        );

        final result = await dataSource.getTalks(favorites: true);
        expect(
          result,
          isA<PaginatedResult<Talk>>().having(
            (result) => result.items,
            'talks',
            contains(TestHelpers.favoriteTalk),
          ),
        );
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<Talk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.talk, Talk.classType),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getTalks(),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<Talk>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getTalks(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.list(Talk.classType)).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getTalks(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });
  });
}
