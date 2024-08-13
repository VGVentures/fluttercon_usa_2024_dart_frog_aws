import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:user_repository/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context) async {
  final userRepository = context.read<UserRepository>();
  try {
    final user = await userRepository.getCurrentUser();

    if (user == null) {
      return Response(statusCode: HttpStatus.unauthorized);
    }

    return Response(body: jsonEncode(user.toJson()));
  } on AmplifyAuthException catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode(e.exception),
    );
  }
}
