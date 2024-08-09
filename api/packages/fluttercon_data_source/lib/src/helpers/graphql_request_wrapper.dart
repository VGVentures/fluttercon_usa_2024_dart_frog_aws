import 'package:amplify_api_dart/amplify_api_dart.dart';
import 'package:amplify_core/amplify_core.dart';

/// {@template request_generator}
/// Wrapper around static Amplify helpers that make GraphQL requests.
/// {@endtemplate}
class GraphQLRequestWrapper {
  /// Wrapper around the static [ModelQueries.list] helper.
  GraphQLRequest<PaginatedResult<T>> Function<T extends Model>(
    ModelType<T> modelType, {
    int? limit,
    QueryPredicate? where,
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) list = ModelQueries.list;
}
