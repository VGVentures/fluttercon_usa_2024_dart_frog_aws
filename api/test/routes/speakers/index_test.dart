import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/speakers/index.dart' as route;
import '../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockFlutterconDataSource extends Mock implements FlutterconDataSource {}

void main() {
  late FlutterconDataSource dataSource;

  setUp(() {
    dataSource = _MockFlutterconDataSource();
  });

  group('GET /speakers', () {
    final responseData = PaginatedResult<Speaker>(
      [
        Speaker(
          id: '1',
          name: 'John Doe',
          bio: 'A bio',
        ),
      ],
      null,
      null,
      null,
      Speaker.classType,
      null,
    );
    test('responds with a 200 and a list of speakers when successful',
        () async {
      final context = _MockRequestContext();
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<FlutterconDataSource>()).thenReturn(dataSource);
      when(() => dataSource.getSpeakers())
          .thenAnswer((_) async => responseData);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.body(), equals(jsonEncode(responseData.toJson())));
    });

    test('responds with a 500 and exception when there is a failure', () async {
      final context = _MockRequestContext();
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      const amplifyException = AmplifyApiException(exception: 'oops');
      when(() => context.request).thenReturn(request);
      when(() => context.read<FlutterconDataSource>()).thenReturn(dataSource);
      when(() => dataSource.getSpeakers()).thenThrow(amplifyException);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.internalServerError));
      expect(
        await response.body(),
        equals(jsonEncode(amplifyException.exception)),
      );
    });

    group('Unsupported methods', () {
      test('respond with 405', () async {
        final context = _MockRequestContext();
        when(() => context.read<FlutterconDataSource>()).thenReturn(
          dataSource,
        );
        FutureOr<Response> action() => route.onRequest(context);
        await testMethodNotAllowed(context, action, 'POST');
        await testMethodNotAllowed(context, action, 'DELETE');
        await testMethodNotAllowed(context, action, 'PUT');
        await testMethodNotAllowed(context, action, 'PATCH');
        await testMethodNotAllowed(context, action, 'HEAD');
        await testMethodNotAllowed(context, action, 'OPTIONS');
      });
    });
  });
}
