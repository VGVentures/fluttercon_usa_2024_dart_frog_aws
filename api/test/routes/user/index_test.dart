import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../../../routes/user/index.dart' as route;
import '../../helpers/method_not_allowed.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository userRepo;

  setUp(() {
    userRepo = _MockUserRepository();
  });
  group('GET /user', () {
    const responseData = User(
      id: '1',
      sessionToken: 'abc',
    );

    test('responds with a 200 and current user when successful', () async {
      final context = _MockRequestContext();
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<UserRepository>()).thenReturn(userRepo);
      when(() => userRepo.getCurrentUser())
          .thenAnswer((_) async => responseData);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.body(), equals(jsonEncode(responseData.toJson())));
    });

    test('responds with a 401 when user is not found', () async {
      final context = _MockRequestContext();
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<UserRepository>()).thenReturn(userRepo);
      when(() => userRepo.getCurrentUser()).thenAnswer((_) async => null);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.unauthorized));
    });

    group('Unsupported methods', () {
      test('respond with 405', () async {
        final context = _MockRequestContext();
        when(() => context.read<UserRepository>()).thenReturn(userRepo);
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
