import 'dart:convert';
import 'dart:io';

import 'package:api/helpers/request_body_decoder.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:fluttercon_shared_models/fluttercon_shared_models.dart';
import 'package:talks_repository/talks_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    HttpMethod.post => await _post(context),
    HttpMethod.delete => await _delete(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context) async {
  final talksRepo = context.read<TalksRepository>();
  try {
    final userId = context.request.uri.queryParameters['userId'] ?? '';
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

Future<Response> _post(RequestContext context) async {
  final talksRepo = context.read<TalksRepository>();
  try {
    late final CreateFavoriteRequest requestBody;
    requestBody = CreateFavoriteRequest.fromJson(
      await context.request.decodeRequestBody(),
    );

    final createResponse = await talksRepo.createFavorite(
      request: requestBody,
    );
    final json = createResponse.toJson();
    return Response(body: jsonEncode(json));
  } on AmplifyApiException catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode(e.exception.toString()),
    );
  }
}

Future<Response> _delete(RequestContext context) async {
  final talksRepo = context.read<TalksRepository>();
  try {
    late final DeleteFavoriteRequest requestBody;
    requestBody = DeleteFavoriteRequest.fromJson(
      await context.request.decodeRequestBody(),
    );

    final deleteResponse = await talksRepo.deleteFavorite(
      request: requestBody,
    );
    final json = deleteResponse.toJson();
    return Response(body: jsonEncode(json));
  } on AmplifyApiException catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode(e.exception.toString()),
    );
  }
}
