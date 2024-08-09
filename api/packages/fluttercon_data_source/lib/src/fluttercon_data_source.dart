import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:fluttercon_data_source/src/amplify_api_client.dart';
import 'package:fluttercon_data_source/src/exceptions/exceptions.dart';

import 'package:fluttercon_data_source/src/models/models.dart';

/// Function that takes a [GraphQLRequest]
/// and returns a [GraphQLOperation].
typedef GraphQLOperator<T> = GraphQLOperation<T> Function(GraphQLRequest<T>);

/// {@template fluttercon_data_source}
/// Data access layer for FlutterCon demo app.
/// Uses Amplify API to interact with the backend.
/// {@endtemplate}
class FlutterconDataSource {
  /// {@macro fluttercon_data_source}
  const FlutterconDataSource({required AmplifyAPIClient apiClient})
      : _apiClient = apiClient;

  final AmplifyAPIClient _apiClient;

  /// Fetches a paginated list of speakers.
  Future<PaginatedResult<Speaker>> getSpeakers() async {
    try {
      final request = _apiClient.list(Speaker.classType);
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  /// Fetches a paginated list of talks.
  Future<PaginatedResult<Talk>> getTalks({bool favorites = false}) async {
    try {
      final request = favorites
          ? _apiClient.list(
              Talk.classType,
              where: Talk.ISFAVORITE.eq(true),
            )
          : _apiClient.list(Talk.classType);
      return await _sendGraphQLRequest(
        request: request,
        operation: (request) => _apiClient.query(request: request),
      );
    } on Exception catch (e) {
      throw AmplifyApiException(exception: e);
    }
  }

  Future<T> _sendGraphQLRequest<T>({
    required GraphQLRequest<T> request,
    required GraphQLOperator<T> operation,
  }) async {
    final response = await operation(request).response;
    if (response.hasErrors) {
      throw AmplifyApiException(exception: response.errors);
    }
    if (response.data == null) {
      throw AmplifyApiException(
        exception: 'No $T Data Found for Request: $request',
      );
    }
    return response.data!;
  }
}
