import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:speakers_repository/speakers_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context, id),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context, String id) async {
  final speakersRepo = context.read<SpeakersRepository>();
  try {
    final userId = context.request.uri.queryParameters['userId'] ?? '';
    final data = await speakersRepo.getSpeaker(id: id, userId: userId);
    final json = data.toJson();
    return Response(body: jsonEncode(json));
  } on AmplifyApiException catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode(e.exception.toString()),
    );
  }
}
