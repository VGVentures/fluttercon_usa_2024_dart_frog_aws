import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:amplify_core/amplify_core.dart';

/// {@template amplify_api_client}
/// Wrapper around Amplify API.
/// {@endtemplate}
class AmplifyAPIClient {
  /// {@macro amplify_api_client}
  AmplifyAPIClient({
    required APICategory api,
    required RequestGenerator requestGenerator,
  })  : _api = api,
        _requestGenerator = requestGenerator;

  final APICategory _api;
  final RequestGenerator _requestGenerator;

  GraphQLRequest<PaginatedResult<T>> list<T extends Model>(
    ModelType<T> modelType, {
    int? limit,
    QueryPredicate? where,
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    return _requestGenerator.list<T>(
      modelType,
      limit: limit,
      where: where,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }

  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) =>
      _api.query(request: request);
}

/// {@template request_generator}
/// Wrapper around Amplify factories that GraphQL requests.
/// {@endtemplate}
class RequestGenerator {
  GraphQLRequest<PaginatedResult<T>> list<T extends Model>(
    ModelType<T> modelType, {
    int? limit,
    QueryPredicate? where,
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    return ModelQueries.list<T>(
      modelType,
      limit: limit,
      where: where,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }
}
