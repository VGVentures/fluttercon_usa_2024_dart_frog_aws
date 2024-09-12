import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:talks_repository/talks_repository.dart';
import 'package:user_repository/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context) async {
  final talksRepo = context.read<TalksRepository>();
  final userRepo = context.read<UserRepository>();
  try {
    final user = await userRepo.getCurrentUser();
    final data = await talksRepo.getTalks(userId: user?.id ?? '');
    final json = data.toJson(
      (value) => value.toJson(),
    );
    return Response(body: jsonEncode(json));
  } on AmplifyApiException catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode(e.exception.toString()),
    );
  }
}
