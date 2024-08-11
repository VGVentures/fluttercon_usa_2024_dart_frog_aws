import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => await _get(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<FlutterconDataSource>();
  try {
    final data = await dataSource.getSpeakers();
    return Response(body: jsonEncode(data.toJson()));
  } on AmplifyApiException catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
      body: jsonEncode(e.exception),
    );
  }
}
