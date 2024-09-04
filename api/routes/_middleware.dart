import 'package:amplify_core/amplify_core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:fluttercon_cache/fluttercon_cache.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:hive/hive.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:speakers_repository/speakers_repository.dart';
import 'package:talks_repository/talks_repository.dart';
import 'package:user_repository/user_repository.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        provider<SpeakersRepository>(
          (context) => SpeakersRepository(
            dataSource: context.read<FlutterconDataSource>(),
          ),
        ),
      )
      .use(
        provider<Future<TalksRepository>>(
          (context) async => TalksRepository(
            dataSource: context.read<FlutterconDataSource>(),
            cache: await context.read<Future<FlutterconCache>>(),
          ),
        ),
      )
      .use(
        provider<Future<FlutterconCache>>(
          (_) async {
            final box = Hive.box('fluttercon_cache');
            await Hive.openBox('fluttercon_cache');
            return FlutterconHiveCache(
              box,
            );
          },
        ),
      )
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
        bearerAuthentication<User>(
          authenticator: (context, token) {
            final userRepository = context.read<UserRepository>();
            return userRepository.verifyUserFromToken(token);
          },
          applies: (context) async =>
              !context.request.uri.pathSegments.contains('user'),
        ),
      )
      .use(
        provider<UserRepository>(
          (context) =>
              UserRepository(authClient: AmplifyAuthClient(auth: Amplify.Auth)),
        ),
      )
      .use(
        fromShelfMiddleware(
          corsHeaders(
            headers: {
              ACCESS_CONTROL_ALLOW_ORIGIN: '*',
            },
          ),
        ),
      );
}
