import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/counter/counter.dart';
import 'package:fluttercon_usa_2024/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({required this.api, super.key});

  final FlutterconApi api;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: api,
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: context.l10n.talksTabText,
              ),
              Tab(
                text: context.l10n.speakersTabText,
              ),
              Tab(
                text: context.l10n.favoritesTabText,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CounterPage(),
            Center(
              child: Text('Speakers coming soon!'),
            ),
            Center(
              child: Text('Favorites coming soon!'),
            ),
          ],
        ),
      ),
    );
  }
}
