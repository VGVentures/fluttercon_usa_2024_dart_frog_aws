import 'package:amplify_core/amplify_core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:user_repository/user_repository.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        provider<FlutterconDataSource>(
          (_) => FlutterconDataSource(
            apiClient: AmplifyAPIClient(
              api: Amplify.API,
              requestWrapper: GraphQLRequestWrapper(),
            ),
          ),
        ),
      )
      .use(
    bearerAuthentication<AuthUser>(
      authenticator: (context, token) {
        final userRepository = context.read<UserRepository>();
        //change this to fetch from access token
        // maybe check provided token against the user in fetchAuthSession
        // and return error if they don't match?
        return userRepository.getCurrentUser();
      },
    ),
  ).use(
    provider<UserRepository>(
      (context) =>
          UserRepository(authClient: AmplifyAuthClient(auth: Amplify.Auth)),
    ),
  );
}
