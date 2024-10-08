// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockBaseApiClient extends Mock implements BaseApiClient {}

void main() {
  group('FlutterconApi', () {
    late BaseApiClient client;
    late FlutterconApi flutterconApi;
    const baseUrl = 'http://127.0.0.1';

    setUpAll(() {
      registerFallbackValue(Request('GET', Uri()));
    });

    setUp(() {
      client = _MockBaseApiClient();
      flutterconApi = FlutterconApi(
        baseUrl: baseUrl,
        client: client,
      );
    });

    test('can be instantiated', () {
      expect(flutterconApi, isNotNull);
    });

    test('can be instantiated with default client', () {
      expect(FlutterconApi(baseUrl: baseUrl), isNotNull);
    });

    void whenHttpClientSend<T>({
      required Uri url,
      int httpStatus = HttpStatus.ok,
      T? response,
      HttpMethod method = HttpMethod.get,
      Exception? exception,
    }) {
      final whenCallback = when(
        () => client.send(
          any(
            that: isA<Request>()
                .having(
                  (req) => req.method,
                  'method',
                  method.name.toUpperCase(),
                )
                .having((req) => req.url, 'url', url),
          ),
        ),
      );

      if (exception != null) {
        whenCallback.thenThrow(exception);
      } else {
        whenCallback.thenAnswer(
          (_) async => StreamedResponse(
            Stream.value(
              utf8.encode(jsonEncode(response)),
            ),
            httpStatus,
          ),
        );
      }
    }

    group('setToken', () {
      late BaseApiClient baseClientWithToken;
      late FlutterconApi apiWithToken;

      setUp(() {
        baseClientWithToken = BaseApiClient(innerClient: client);
        apiWithToken = FlutterconApi(
          baseUrl: baseUrl,
          client: baseClientWithToken,
        );
        whenHttpClientSend(
          url: Uri.parse('$baseUrl/user'),
          response: TestHelpers.userResponse,
        );
      });

      test(
        'sets token from api call',
        () async {
          await apiWithToken.setToken();

          expect(
            baseClientWithToken.token,
            equals(
              TestHelpers.userResponse['sessionToken'],
            ),
          );
          verify(() => client.send(any())).called(1);
        },
      );

      test('does not re-call api if current user has been fetched', () async {
        await apiWithToken.getUser();
        await apiWithToken.setToken();

        expect(
          baseClientWithToken.token,
          equals(
            TestHelpers.userResponse['sessionToken'],
          ),
        );
        verify(() => client.send(any())).called(1);
      });
    });

    group('getUser', () {
      final url = Uri.parse('$baseUrl/user');

      test('returns User on successful response', () async {
        whenHttpClientSend(
          url: url,
          response: TestHelpers.userResponse,
        );

        final user = await flutterconApi.getUser();

        expect(user, isA<User>());
      });

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(url: url, response: '');

          expect(
            () async => flutterconApi.getUser(),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: url,
            // ignore: inference_failure_on_collection_literal
            response: {},
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.getUser(),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(HttpStatus.notFound),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<User>(url: url, exception: Exception('oops'));

          expect(
            () async => flutterconApi.getUser(),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('getSpeakers', () {
      final url = Uri.parse('$baseUrl/speakers');

      test(
        'returns ${PaginatedData<TalkTimeSlot>} on successful response',
        () async {
          whenHttpClientSend(url: url, response: TestHelpers.speakersResponse);

          final talks = await flutterconApi.getSpeakers();

          expect(talks, isA<PaginatedData<SpeakerPreview>>());
        },
      );

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(url: url, response: '');

          expect(
            () async => flutterconApi.getSpeakers(),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: url,
            // ignore: inference_failure_on_collection_literal
            response: {},
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.getSpeakers(),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<TalkTimeSlot>(
            url: url,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.getSpeakers(),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('getSpeaker', () {
      const speakerId = 'speakerId';
      final url = Uri.parse(
        '$baseUrl/speakers/$speakerId?userId=${TestHelpers.userId}',
      );

      test('returns $SpeakerDetail on successful response', () async {
        whenHttpClientSend(
          url: url,
          response: TestHelpers.speakerDetailResponse,
        );

        final speaker = await flutterconApi.getSpeaker(
          id: speakerId,
          userId: TestHelpers.userId,
        );

        expect(speaker, isA<SpeakerDetail>());
      });

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(url: url, response: '');

          expect(
            () async => flutterconApi.getSpeaker(
              id: speakerId,
              userId: TestHelpers.userId,
            ),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: url,
            // ignore: inference_failure_on_collection_literal
            response: {},
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.getSpeaker(
              id: speakerId,
              userId: TestHelpers.userId,
            ),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<SpeakerDetail>(
            url: url,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.getSpeaker(
              id: speakerId,
              userId: TestHelpers.userId,
            ),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('getTalks', () {
      final url = Uri.parse('$baseUrl/talks?userId=${TestHelpers.userId}');

      setUp(() {
        whenHttpClientSend(
          url: Uri.parse('$baseUrl/user'),
          response: TestHelpers.userResponse,
        );
      });

      test(
        'returns ${PaginatedData<TalkTimeSlot>} on successful response',
        () async {
          whenHttpClientSend(url: url, response: TestHelpers.talksResponse);

          final talks = await flutterconApi.getTalks(
            userId: TestHelpers.userId,
          );

          expect(talks, isA<PaginatedData<TalkTimeSlot>>());
        },
      );

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(url: url, response: '');

          expect(
            () async => flutterconApi.getTalks(
              userId: TestHelpers.userId,
            ),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: url,
            // ignore: inference_failure_on_collection_literal
            response: {},
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.getTalks(
              userId: TestHelpers.userId,
            ),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<TalkTimeSlot>(
            url: url,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.getTalks(
              userId: TestHelpers.userId,
            ),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('getTalk', () {
      const talkId = 'talkId';
      final url = Uri.parse('$baseUrl/talks/$talkId');

      test('returns $TalkDetail on successful response', () async {
        whenHttpClientSend(
          url: url,
          response: TestHelpers.talkDetailResponse,
        );

        final talk = await flutterconApi.getTalk(id: talkId);

        expect(talk, isA<TalkDetail>());
      });

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(url: url, response: '');

          expect(
            () async => flutterconApi.getTalk(id: talkId),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: url,
            // ignore: inference_failure_on_collection_literal
            response: {},
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.getTalk(id: talkId),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<TalkDetail>(
            url: url,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.getTalk(id: talkId),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('addFavorite', () {
      final uri = Uri.parse('$baseUrl/favorites');

      test('returns $CreateFavoriteResponse on successful response', () async {
        whenHttpClientSend(
          url: uri,
          response: TestHelpers.createFavoriteResponse,
          method: HttpMethod.post,
        );

        final response = await flutterconApi.addFavorite(
          request: TestHelpers.createFavoriteRequest,
        );

        expect(response, isA<CreateFavoriteResponse>());
      });

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(
            url: uri,
            response: '',
            method: HttpMethod.post,
          );

          expect(
            () async => flutterconApi.addFavorite(
              request: TestHelpers.createFavoriteRequest,
            ),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: uri,
            // ignore: inference_failure_on_collection_literal
            response: {},
            method: HttpMethod.post,
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.addFavorite(
              request: TestHelpers.createFavoriteRequest,
            ),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<CreateFavoriteResponse>(
            url: uri,
            method: HttpMethod.post,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.addFavorite(
              request: TestHelpers.createFavoriteRequest,
            ),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('removeFavorite', () {
      final uri = Uri.parse('$baseUrl/favorites');

      test('returns $DeleteFavoriteResponse on successful response', () async {
        whenHttpClientSend(
          url: uri,
          response: TestHelpers.deleteFavoriteResponse,
          method: HttpMethod.delete,
        );

        final response = await flutterconApi.removeFavorite(
          request: TestHelpers.deleteFavoriteRequest,
        );

        expect(response, isA<DeleteFavoriteResponse>());
      });

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(
            url: uri,
            response: '',
            method: HttpMethod.delete,
          );

          expect(
            () async => flutterconApi.removeFavorite(
              request: TestHelpers.deleteFavoriteRequest,
            ),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: uri,
            // ignore: inference_failure_on_collection_literal
            response: {},
            method: HttpMethod.delete,
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.removeFavorite(
              request: TestHelpers.deleteFavoriteRequest,
            ),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<DeleteFavoriteResponse>(
            url: uri,
            method: HttpMethod.delete,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.removeFavorite(
              request: TestHelpers.deleteFavoriteRequest,
            ),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });

    group('getFavorites', () {
      const userId = 'userId';
      final url = Uri.parse('$baseUrl/favorites?userId=$userId');

      test(
        'returns ${PaginatedData<TalkTimeSlot>} on successful response',
        () async {
          whenHttpClientSend(url: url, response: TestHelpers.talksResponse);

          final talks = await flutterconApi.getFavorites(userId: userId);

          expect(talks, isA<PaginatedData<TalkTimeSlot>>());
        },
      );

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {
          whenHttpClientSend(url: url, response: '');

          expect(
            () async => flutterconApi.getFavorites(userId: userId),
            throwsA(isA<FlutterconApiMalformedResponseException>()),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {
          whenHttpClientSend(
            url: url,
            // ignore: inference_failure_on_collection_literal
            response: {},
            httpStatus: HttpStatus.notFound,
          );

          expect(
            () async => flutterconApi.getFavorites(userId: userId),
            throwsA(
              isA<FlutterconApiClientException>().having(
                (e) => e.statusCode,
                'status code',
                equals(
                  HttpStatus.notFound,
                ),
              ),
            ),
          );
        },
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {
          whenHttpClientSend<TalkTimeSlot>(
            url: url,
            exception: Exception('oops'),
          );

          expect(
            () async => flutterconApi.getFavorites(userId: userId),
            throwsA(
              isA<FlutterconApiClientException>(),
            ),
          );
        },
      );
    });
  });
}
