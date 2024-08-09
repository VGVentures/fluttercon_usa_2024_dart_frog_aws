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

  /// Send a GraphQL [query] with a given [request].
  GraphQLOperation<T> query<T>({required GraphQLRequest<T> request}) =>
      _api.query(request: request);
}
