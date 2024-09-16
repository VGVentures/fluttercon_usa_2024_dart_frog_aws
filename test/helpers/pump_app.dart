import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/l10n/l10n.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class _MockFlutterconApi extends Mock implements FlutterconApi {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    FlutterconApi? api,
    UserCubit? userCubit,
  }) {
    return mockNetworkImagesFor(
      () => pumpWidget(
        RepositoryProvider.value(
          value: api ?? _MockFlutterconApi(),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Material(
              child: userCubit != null
                  ? BlocProvider.value(
                      value: userCubit,
                      child: widget,
                    )
                  : widget,
            ),
          ),
        ),
      ),
    );
  }
}
