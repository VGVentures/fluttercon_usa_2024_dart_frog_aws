// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/test_helpers.dart';

class _MockBaseApiClient extends Mock implements BaseApiClient {}

class _MockClient extends Mock implements Client {}

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

    group('setToken', () {
      test(
        'sets token from fetched user',
        () {},
      );

      test('sets token from existing user', () {});
    });

    group('getUser', () {
      test('returns User on successful response', () async {
        when(() => client.send(any())).thenAnswer(
          (_) async => StreamedResponse(
            Stream.value(utf8.encode(jsonEncode(TestHelpers.userResponse))),
            200,
          ),
        );

        final user = await flutterconApi.getUser();

        expect(user, isA<User>());
      });

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {},
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {},
      );

      test(
          'throws $FlutterconApiClientException '
          'when an unexpected error occurs',
          () async {});
    });

    group('getTalks', () {
      test(
        'returns ${PaginatedData<TalkPreview>} on successful response',
        () async {},
      );

      test(
        'throws $FlutterconApiMalformedResponseException '
        'when body is malformed',
        () async {},
      );

      test(
        'throws $FlutterconApiClientException '
        'when response is not successful',
        () async {},
      );

      test(
        'throws $FlutterconApiClientException '
        'when an unexpected error occurs',
        () async {},
      );
    });
  });
}
