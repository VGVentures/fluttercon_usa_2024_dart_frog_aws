import 'package:amplify_core/amplify_core.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
        provider<FlutterconDataSource>(
          (_) => FlutterconDataSource(
            apiClient: AmplifyAPIClient(
              api: Amplify.API,
              requestWrapper: GraphQLRequestWrapper(),
            ),
          ),
        ),
      );
}
