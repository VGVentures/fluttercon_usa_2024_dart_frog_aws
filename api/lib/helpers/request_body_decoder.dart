import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

/// Helper to decode dart frog request bodies
extension RequestBodyDecoder on Request {
  /// Returns the request body as a `Map<String, dynamic>`
  Future<Map<String, dynamic>> decodeRequestBody() async =>
      Map<String, dynamic>.from(jsonDecode(await body()) as Map);
}
