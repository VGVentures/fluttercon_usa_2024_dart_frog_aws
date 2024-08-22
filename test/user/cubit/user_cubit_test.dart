import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_data.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

void main() {
  group('UserCubit', () {
    late FlutterconApi api;
    late UserCubit cubit;

    setUp(() {
      api = _MockFlutterconApi();
      cubit = UserCubit(api: api);
    });

    test('initial state is null', () {
      expect(cubit.state, null);
    });

    group('getUser', () {
      test('emits user', () async {
        when(api.getUser).thenAnswer((_) async => TestData.user);

        await cubit.getUser();

        expect(cubit.state, equals(TestData.user));
      });
    });
  });
}
