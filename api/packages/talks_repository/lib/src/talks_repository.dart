import 'package:fluttercon_data_source/fluttercon_data_source.dart';

/// {@template talks_repository}
/// A repository to cache and prepare talk data retrieved from the api.
/// {@endtemplate}
class TalksRepository {
  /// {@macro talks_repository}
  const TalksRepository({
    required FlutterconDataSource dataSource,
  }) : _dataSource = dataSource;

  final FlutterconDataSource _dataSource;
}
