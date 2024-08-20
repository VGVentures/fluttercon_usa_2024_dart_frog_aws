import 'dart:convert';
import 'dart:io';

import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements Client {}

class _MockRequest extends Mock implements Request {}

void main() {
  late Client httpClient;
  late Request request;
  late BaseApiClient baseApiClient;
  const token = 'token';

  setUpAll(() {
    registerFallbackValue(Request('GET', Uri()));
  });

  setUp(() {
    httpClient = _MockHttpClient();
    request = _MockRequest();
    baseApiClient = BaseApiClient(innerClient: httpClient);

    when(() => httpClient.send(any())).thenAnswer(
      (_) async => StreamedResponse(
        Stream.value(utf8.encode('')),
        HttpStatus.ok,
      ),
    );
    request = _MockRequest();
    when(() => request.headers).thenReturn({});
  });

  group('BaseApiClient', () {
    test('can be instantiated', () {
      expect(
        baseApiClient,
        isNotNull,
      );
    });

    group('send', () {
      test('adds content type and accept headers', () async {
        await baseApiClient.send(request);
        expect(
          request.headers,
          equals(
            {
              HttpHeaders.contentTypeHeader: ContentType.json.value,
              HttpHeaders.acceptHeader: ContentType.json.value,
            },
          ),
        );
      });

      test('adds auth header when token is present', () async {
        addTearDown(() {
          baseApiClient.token = null;
        });
        baseApiClient.token = token;
        await baseApiClient.send(request);
        expect(
          request.headers,
          equals(
            {
              HttpHeaders.contentTypeHeader: ContentType.json.value,
              HttpHeaders.acceptHeader: ContentType.json.value,
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
          ),
        );
      });
    });

    group('close', () {
      test('closes inner client on close', () {
        when(() => httpClient.close()).thenAnswer((_) {});
        baseApiClient.close();
        verify(() => httpClient.close()).called(1);
      });
    });
  });
}
