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
      when(() => auth.getPlugin(AmplifyAuthCognitoDart.pluginKey))
          .thenReturn(plugin);
      client = AmplifyAuthClient(auth: auth);
    });

    test('can be instantiated', () {
      expect(client, isNotNull);
    });

    group('fetchAuthSession', () {
      test('calls auth fetchAuthSession', () async {
        when(() => plugin.fetchAuthSession())
            .thenAnswer((_) async => TestHelpers.cognitoAuthSession());

        await client.fetchAuthSession();
        verify(() => plugin.fetchAuthSession()).called(1);
      });
    });
  });
}
