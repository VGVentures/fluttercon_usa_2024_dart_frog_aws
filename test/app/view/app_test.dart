import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/app/app.dart';
import 'package:fluttercon_usa_2024/speakers/view/speakers_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('App', () {
    late FlutterconApi api;

    setUp(() {
      api = _MockFlutterconApi();
      when(api.getUser).thenAnswer((_) async => TestData.user);
    });
    testWidgets('renders $HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          api: api,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('can select different tabs', (tester) async {
      await tester.pumpWidget(
        App(
          api: api,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.people_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SpeakersPage), findsOneWidget);
    });
  });
}
