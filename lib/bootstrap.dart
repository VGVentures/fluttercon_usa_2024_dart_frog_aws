import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/app/view/app.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  runApp(await builder());
}

FutureOr<Widget> buildApp(String baseUrl) async {
  if (baseUrl.isEmpty) {
    throw ArgumentError('baseUrl must not be empty.');
  }

  final api = FlutterconApi(baseUrl: baseUrl);
  await api.setToken();

  return App(api: api);
}
