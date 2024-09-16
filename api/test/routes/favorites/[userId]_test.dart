import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talks_repository/talks_repository.dart';
import 'package:test/test.dart';

import '../../../routes/favorites/[userId].dart' as route;
import '../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockTalksRepository extends Mock implements TalksRepository {}

void main() {
  late TalksRepository talksRepository;
  const userId = 'userId';

  setUp(() {
    talksRepository = _MockTalksRepository();
  });

  group('GET /favorites/[userId]', () {
    final responseData = PaginatedData(
      items: [
        TalkTimeSlot(
          startTime: DateTime(2024),
          talks: [
            TalkPreview(
              id: 'id',
              title: 'title',
              room: 'room',
              startTime: DateTime(2024),
              speakerNames: const ['speakerName'],
              isFavorite: true,
            ),
          ],
        ),
      ],
    );
    test(
      'responds with a 200 and a list of talks by userId when successful',
      () async {
        final context = _MockRequestContext();
        final request = Request('GET', Uri.parse('http://127.0.0.1/'));
        when(() => context.request).thenReturn(request);
        when(() => context.read<TalksRepository>()).thenReturn(talksRepository);
        when(() => talksRepository.getFavorites(userId: userId))
            .thenAnswer((_) async => responseData);

        final response = await route.onRequest(context, userId);
        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          await response.body(),
          equals(jsonEncode(responseData.toJson((value) => value.toJson()))),
        );
      },
    );

    test(
      'responds with a 500 and an exception when there is a failure',
      () async {
        final context = _MockRequestContext();
        final request = Request('GET', Uri.parse('http://127.0.0.1/'));
        const amplifyException = AmplifyApiException(exception: 'oops');
        when(() => context.request).thenReturn(request);
        when(() => context.read<TalksRepository>()).thenReturn(talksRepository);
        when(() => talksRepository.getFavorites(userId: userId))
            .thenThrow(amplifyException);

        final response = await route.onRequest(context, userId);
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
      FutureOr<Response> action() => route.onRequest(context, userId);
      await testMethodNotAllowed(context, action, 'POST');
      await testMethodNotAllowed(context, action, 'DELETE');
      await testMethodNotAllowed(context, action, 'PUT');
      await testMethodNotAllowed(context, action, 'PATCH');
      await testMethodNotAllowed(context, action, 'HEAD');
      await testMethodNotAllowed(context, action, 'OPTIONS');
    });
  });
}
