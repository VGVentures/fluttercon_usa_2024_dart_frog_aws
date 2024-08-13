import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/test_helpers.dart';

class _MockAuthCategory extends Mock implements AuthCategory {}

class _MockAmplifyAuthCognitoDart extends Mock
    implements AmplifyAuthCognitoDart {}

void main() {
  group('AmplifyAuthClient', () {
    late AuthCategory auth;
    late AmplifyAuthCognitoDart plugin;
    late AmplifyAuthClient client;

    setUp(() {
      auth = _MockAuthCategory();
      plugin = _MockAmplifyAuthCognitoDart();

      client = AmplifyAuthClient(auth: auth);
    });

    test('can be instantiated', () {
      expect(client, isNotNull);
    });

    group('getCurrentUser', () {
      test('calls auth getCurrentUser', () async {
        when(() => auth.getCurrentUser())
            .thenAnswer((_) async => TestHelpers.amplifyUser);

        await client.getCurrentUser();
        verify(() => auth.getCurrentUser()).called(1);
      });
    });

    group('getSessionToken', () {
      test('calls auth fetchAuthSession', () async {
        when(() => auth.getPlugin(AmplifyAuthCognitoDart.pluginKey))
            .thenReturn(plugin);
        when(() => plugin.fetchAuthSession()).thenAnswer(
          (_) async => TestHelpers.cognitoAuthSession,
        );

        await client.getSessionToken();
        verify(() => plugin.fetchAuthSession()).called(1);
      });
    });
  });
}
