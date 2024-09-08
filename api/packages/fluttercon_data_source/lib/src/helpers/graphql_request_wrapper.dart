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

  /// Wrapper around the static [ModelQueries.get] helper.
  GraphQLRequest<T> Function<T extends Model>(
    ModelType<T> modelType,
    ModelIdentifier<T> modelIdentifier, {
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) get = ModelQueries.get;

  /// Wrapper around the static [ModelMutations.create] helper.
  GraphQLRequest<T> Function<T extends Model>(
    T model, {
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) create = ModelMutations.create;

  /// Wrapper around the static [ModelMutations.deleteById] helper.
  GraphQLRequest<T> Function<T extends Model>(
    ModelType<T> modelType,
    ModelIdentifier<T> modelIdentifier, {
    String? apiName,
    APIAuthorizationType? authorizationMode,
    Map<String, String>? headers,
  }) deleteById = ModelMutations.deleteById;
}
