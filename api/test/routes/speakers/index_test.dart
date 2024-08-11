import 'dart:convert';
import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/speakers/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockFlutterconDataSource extends Mock implements FlutterconDataSource {}

void main() {
  late FlutterconDataSource dataSource;

  setUp(() {
    dataSource = _MockFlutterconDataSource();
  });

  group('GET /speakers', () {
    final responseData = PaginatedResult<Speaker>(
      [
        Speaker(
          id: '1',
          name: 'John Doe',
          bio: 'A bio',
        )
      ],
      null,
      null,
      null,
      Speaker.classType,
      null,
    );
    test('responds with a 200 and a list of speakers.', () async {
      final context = _MockRequestContext();
      final request = Request('GET', Uri.parse('http://127.0.0.1/'));
      when(() => context.request).thenReturn(request);
      when(() => context.read<FlutterconDataSource>()).thenReturn(dataSource);
      when(() => dataSource.getSpeakers())
          .thenAnswer((_) async => responseData);

      final response = await onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.body(), equals(jsonEncode(responseData.toJson())));
    });
  });
}
