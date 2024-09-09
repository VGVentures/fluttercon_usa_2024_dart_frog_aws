import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:talks_repository/talks_repository.dart';

Future<Response> onRequest(RequestContext context, String userId) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context, userId),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context, String userId) async {
  final talksRepo = context.read<TalksRepository>();
  try {
    final data = await talksRepo.getFavorites(
      userId: userId,
    );
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
