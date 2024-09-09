import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/src/helpers/graphql_request_wrapper.dart';

/// {@template amplify_api_client}
/// Wrapper around Amplify API.
/// {@endtemplate}
class AmplifyAPIClient {
  /// {@macro amplify_api_client}
  AmplifyAPIClient({
    required APICategory api,
    required GraphQLRequestWrapper requestWrapper,
  })  : _api = api,
        _requestWrapper = requestWrapper;

  final APICategory _api;
  final GraphQLRequestWrapper _requestWrapper;

  /// Create a GraphQL [get] request.
  GraphQLRequest<T> get<T extends Model>(
    ModelType<T> modelType,
    ModelIdentifier<T> modelIdentifier, {
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    return _requestWrapper.get<T>(
      modelType,
      modelIdentifier,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }

  /// Create a GraphQL [list] request.
  GraphQLRequest<PaginatedResult<T>> list<T extends Model>(
    ModelType<T> modelType, {
    int? limit,
    QueryPredicate? where,
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    return _requestWrapper.list<T>(
      modelType,
      limit: limit,
      where: where,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }

  /// Create a GraphQL [create] request.
  GraphQLRequest<T> create<T extends Model>(
    T model, {
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    return _requestWrapper.create<T>(
      model,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }

  /// Create a GraphQL [deleteById] request.
  GraphQLRequest<T> deleteById<T extends Model>(
    ModelType<T> modelType,
    ModelIdentifier<T> modelIdentifier, {
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) {
    return _requestWrapper.deleteById<T>(
      modelType,
      modelIdentifier,
      apiName: apiName,
      authorizationMode: authorizationMode,
      headers: headers,
    );
  }

  /// Send a GraphQL [query] with a given [request].
  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) =>
      _api.query(request: request);

  /// Send a GraphQL [mutate] with a given [request].
  GraphQLOperation<T> mutate<T>({required GraphQLRequest<T> request}) =>
      _api.mutate(request: request);
}
