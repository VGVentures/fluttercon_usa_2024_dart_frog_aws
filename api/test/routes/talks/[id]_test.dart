import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talks_repository/talks_repository.dart';
import 'package:test/test.dart';

import '../../../routes/talks/[id].dart' as route;
import '../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockTalksRepository extends Mock implements TalksRepository {}

void main() {
  late TalksRepository talksRepository;
  const talkId = 'id';

  setUp(() {
    talksRepository = _MockTalksRepository();
  });

  group('GET /talks/:id', () {
    final responseData = TalkDetail(
      id: talkId,
      title: 'title',
      room: 'room',
      startTime: DateTime(2024),
      speakers: const [],
      description: '',
    );

    test('responds with a 200 and a $TalkDetail when successful', () async {
      final context = _MockRequestContext();
      final request =
          Request('GET', Uri.parse('http://127.0.0.1/talks/$talkId'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<TalksRepository>()).thenReturn(talksRepository);
      when(() => talksRepository.getTalk(id: talkId))
          .thenAnswer((_) async => responseData);

      final response = await route.onRequest(context, talkId);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        await response.body(),
        equals(jsonEncode(responseData.toJson())),
      );
    });

    test(
      'responds with a 500 and an exception when there is a failure',
      () async {
        final context = _MockRequestContext();
        final request =
            Request('GET', Uri.parse('http://127.0.0.1/talks/$talkId'));
        const amplifyException = AmplifyApiException(exception: 'oops');

        when(() => context.request).thenReturn(request);
        when(() => context.read<TalksRepository>()).thenReturn(talksRepository);
        when(() => talksRepository.getTalk(id: talkId))
            .thenThrow(amplifyException);

        final response = await route.onRequest(context, talkId);
        expect(response.statusCode, equals(HttpStatus.internalServerError));
        expect(
          await response.body(),
          equals(jsonEncode(amplifyException.exception)),
        );
      },
    );
  });

  group('Unsupported methods', () {
    test('respond with 405', () async {
      final context = _MockRequestContext();
      when(() => context.read<TalksRepository>()).thenReturn(
        talksRepository,
      );
      FutureOr<Response> action() => route.onRequest(context, talkId);
      await testMethodNotAllowed(context, action, 'POST');
      await testMethodNotAllowed(context, action, 'DELETE');
      await testMethodNotAllowed(context, action, 'PUT');
      await testMethodNotAllowed(context, action, 'PATCH');
      await testMethodNotAllowed(context, action, 'HEAD');
      await testMethodNotAllowed(context, action, 'OPTIONS');
    });
  });
}
