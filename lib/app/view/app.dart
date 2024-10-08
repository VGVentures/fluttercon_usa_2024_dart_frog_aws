import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon_api/fluttercon_api.dart';
import 'package:fluttercon_usa_2024/favorites/favorites.dart';
import 'package:fluttercon_usa_2024/l10n/l10n.dart';
import 'package:fluttercon_usa_2024/speakers/speakers.dart';
import 'package:fluttercon_usa_2024/talks/talks.dart';
import 'package:fluttercon_usa_2024/user/cubit/user_cubit.dart';

class App extends StatelessWidget {
  const App({required this.api, super.key});

  final FlutterconApi api;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: api,
      child: BlocProvider(
        lazy: false,
        create: (context) => UserCubit(api: api)..getUser(),
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
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userId = context.select((UserCubit cubit) => cubit.state?.id);
    return userId == null
        ? const CircularProgressIndicator()
        : Scaffold(
            bottomNavigationBar: NavigationBar(
              destinations: [
                NavigationDestination(
                  icon: const Icon(
                    Icons.article_outlined,
                  ),
                  label: context.l10n.talksTabText,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.people_outlined),
                  label: context.l10n.speakersTabText,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.favorite_outline),
                  label: context.l10n.favoritesTabText,
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
            ),
            body: const [
              TalksPage(),
              SpeakersPage(),
              FavoritesPage(),
            ][_selectedIndex],
          );
  }
}
