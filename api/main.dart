import 'dart:io';

import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:amplify_auth_cognito_dart/amplify_auth_cognito_dart.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_secure_storage_dart/amplify_secure_storage_dart.dart';
import 'package:api/amplify_outputs.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/src/models/gen/ModelProvider.dart';
import 'package:hive/hive.dart';

import 'routes/_middleware.dart';

Future<void> init(InternetAddress ip, int port) async {
  Hive.init(Directory.current.path);
  await Hive.openBox<String>(cacheBoxKey);
  final api = AmplifyAPIDart(
    options: APIPluginOptions(modelProvider: ModelProvider.instance),
  );
  if (!Amplify.isConfigured) {
    await Amplify.addPlugin(
      AmplifyAuthCognitoDart(
        secureStorageFactory: AmplifySecureStorageDart.factoryFrom(
          macOSOptions:
              // ignore: invalid_use_of_visible_for_testing_member
              MacOSSecureStorageOptions(useDataProtection: false),
          linuxOptions: LinuxSecureStorageOptions(),
        ),
      ),
    );
    await Amplify.addPlugin(api);
    await Amplify.configure(amplifyConfig);
  }
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) =>
    serve(handler, ip, port);
