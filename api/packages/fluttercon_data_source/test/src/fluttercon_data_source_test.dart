// ignore_for_file: prefer_const_constructors
import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_data_source/src/models/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockAmplifyApiClient extends Mock implements AmplifyAPIClient {}

void main() {
  group('FlutterconDataSource', () {
    late AmplifyAPIClient apiClient;
    late FlutterconDataSource dataSource;

    setUp(() async {
      apiClient = _MockAmplifyApiClient();
      dataSource = FlutterconDataSource(apiClient: apiClient);
    });

    test('can be instantiated', () async {
      expect(dataSource, isNotNull);
    });

    group('getSpeakers', () {
      test('returns ${PaginatedResult<Speaker>} when successful', () async {
        final response = GraphQLOperation<PaginatedResult<Speaker>>(
          CancelableOperation.fromValue(
            GraphQLResponse(
              data: PaginatedResult(
                [_TestData.speaker],
                null,
                null,
                null,
                Speaker.classType,
                null,
              ),
              errors: [],
            ),
          ),
        );

        when(
          () => apiClient.query(request: any(named: 'request')),
        ).thenAnswer((_) => response);

        final result = await dataSource.getSpeakers();
        expect(result, isA<PaginatedResult<Speaker>>());
      });

      test('throws $AmplifyApiException when response has errors', () async {});

      test(
        'throws $AmplifyApiException when response data is null',
        () async {},
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {},
      );
    });

    group('getTalks', () {
      test('returns ${PaginatedResult<Talk>} when successful', () async {});

      test(
        'returns filtered ${PaginatedResult<Talk>} when successful '
        'and [favorites] is true',
        () async {},
      );

      test('throws $AmplifyApiException when response has errors', () async {});

      test(
        'throws $AmplifyApiException when response data is null',
        () async {},
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {},
      );
    });
  });
}

class _TestData {
  static final speaker = Speaker(
    id: '1',
    name: 'John Doe',
    bio: 'Speaker bio',
  );

  static final talk = Talk(
    id: '1',
    title: 'Talk title',
    description: 'Talk description',
    isFavorite: false,
  );
}
