import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/app/app.dart';
import 'package:fluttercon_usa_2024/counter/counter.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('App', () {
    late FlutterconApi api;

    setUp(() {
      api = _MockFlutterconApi();
    });
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App(
        api: api,
      ));
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
