import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speakers_repository/speakers_repository.dart';
import 'package:test/test.dart';

import '../../../routes/speakers/[id].dart' as route;
import '../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockSpeakersRepository extends Mock implements SpeakersRepository {}

void main() {
  late SpeakersRepository speakersRepository;
  const speakerId = 'id';
  const userId = 'userId';

  setUp(() {
    speakersRepository = _MockSpeakersRepository();
  });

  group('GET /speakers/:id', () {
    const responseData = SpeakerDetail(
      id: 'id',
      name: 'name',
      title: 'title',
      imageUrl: 'imageUrl',
      bio: 'bio',
      links: [],
      talks: [],
    );

    test('responds with a 200 and a $SpeakerDetail when successful', () async {
      final context = _MockRequestContext();
      final request = Request(
        'GET',
        Uri.parse('http://127.0.0.1/speakers/$speakerId?userId=$userId'),
      );
      when(() => context.request).thenReturn(request);
      when(() => context.read<SpeakersRepository>())
          .thenReturn(speakersRepository);
      when(() => speakersRepository.getSpeaker(id: speakerId, userId: userId))
          .thenAnswer((_) async => responseData);

      final response = await route.onRequest(context, speakerId);
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
        final request = Request(
          'GET',
          Uri.parse('http://127.0.0.1/talks/$speakerId?userId=$userId'),
        );
        const amplifyException = AmplifyApiException(exception: 'oops');

        when(() => context.request).thenReturn(request);
        when(() => context.read<SpeakersRepository>())
            .thenReturn(speakersRepository);
        when(() => speakersRepository.getSpeaker(id: speakerId, userId: userId))
            .thenThrow(amplifyException);

        final response = await route.onRequest(context, speakerId);
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
      when(() => context.read<SpeakersRepository>()).thenReturn(
        speakersRepository,
      );
      FutureOr<Response> action() => route.onRequest(context, speakerId);
      await testMethodNotAllowed(context, action, 'POST');
      await testMethodNotAllowed(context, action, 'DELETE');
      await testMethodNotAllowed(context, action, 'PUT');
      await testMethodNotAllowed(context, action, 'PATCH');
      await testMethodNotAllowed(context, action, 'HEAD');
      await testMethodNotAllowed(context, action, 'OPTIONS');
    });
  });
}
