import 'dart:io';

import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:api/amplify_outputs.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:fluttercon_data_source/src/models/gen/ModelProvider.dart';

Future<void> init(InternetAddress ip, int port) async {
  final api = AmplifyAPIDart(
    options: APIPluginOptions(modelProvider: ModelProvider.instance),
  );
  if (!Amplify.isConfigured) {
    await Amplify.addPlugin(api);
    await Amplify.configure(amplifyConfig);
  }
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) =>
    serve(handler, ip, port);
