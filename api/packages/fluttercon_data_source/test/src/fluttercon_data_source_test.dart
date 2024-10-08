// ignore_for_file: prefer_const_constructors
import 'package:amplify_core/amplify_core.dart';
import 'package:fluttercon_data_source/fluttercon_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

class _MockAmplifyApiClient extends Mock implements AmplifyAPIClient {}

void main() {
  group('FlutterconDataSource', () {
    late AmplifyAPIClient apiClient;
    late FlutterconDataSource dataSource;

    setUpAll(() {
      registerFallbackValue(Favorites(userId: 'userId'));
      registerFallbackValue(
        FavoritesTalk(
          favorites: Favorites(userId: 'userId'),
          talk: Talk(id: 'talkId'),
        ),
      );
      registerFallbackValue(FavoritesTalk.classType);
      registerFallbackValue(FavoritesTalkModelIdentifier(id: 'id'));
      registerFallbackValue(
        GraphQLRequest<Favorites>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<FavoritesTalk>(document: ''),
      );
      registerFallbackValue(GraphQLRequest<Speaker>(document: ''));

      registerFallbackValue(GraphQLRequest<Talk>(document: ''));

      registerFallbackValue(
        GraphQLRequest<PaginatedResult<Favorites>>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<FavoritesTalk>>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<Link>>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<Speaker>>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<SpeakerTalk>>(document: ''),
      );
      registerFallbackValue(
        GraphQLRequest<PaginatedResult<Talk>>(document: ''),
      );

      registerFallbackValue(
        SpeakerModelIdentifier(id: 'id'),
      );
      registerFallbackValue(
        TalkModelIdentifier(id: 'id'),
      );
    });

    setUp(() {
      apiClient = _MockAmplifyApiClient();
      dataSource = FlutterconDataSource(apiClient: apiClient);
    });

    test('can be instantiated', () async {
      expect(dataSource, isNotNull);
    });

    group('createFavorites', () {
      setUp(() {
        when(
          () => apiClient.create<Favorites>(any()),
        ).thenAnswer(
          (_) => GraphQLRequest<Favorites>(
            document: '',
          ),
        );
      });

      test('returns $Favorites when successful', () async {
        when(
          () => apiClient.mutate<Favorites>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<Favorites>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(TestHelpers.favorites),
        );

        final result = await dataSource.createFavorites(userId: 'userId');
        expect(result, isA<Favorites>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.mutate<Favorites>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<Favorites>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.favorites,
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.createFavorites(userId: 'userId'),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.mutate<Favorites>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<Favorites>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.createFavorites(userId: 'userId'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.mutate<Favorites>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<Favorites>>(),
              ),
            ),
          ).thenThrow(Exception('Error'));

          expect(
            () => dataSource.createFavorites(userId: 'userId'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('createFavoritesTalk', () {
      setUp(() {
        when(
          () => apiClient.create<FavoritesTalk>(any()),
        ).thenAnswer(
          (_) => GraphQLRequest<FavoritesTalk>(
            document: '',
          ),
        );
      });
      test('returns $FavoritesTalk when successful', () async {
        when(
          () => apiClient.mutate<FavoritesTalk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<FavoritesTalk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(TestHelpers.favoritesTalk),
        );

        final result = await dataSource.createFavoritesTalk(
          favoritesId: 'userId',
          talkId: 'talkId',
        );
        expect(result, isA<FavoritesTalk>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.mutate<FavoritesTalk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<FavoritesTalk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.favoritesTalk,
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.createFavoritesTalk(
            favoritesId: 'userId',
            talkId: 'talkId',
          ),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.mutate<FavoritesTalk>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<FavoritesTalk>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.createFavoritesTalk(
              favoritesId: 'userId',
              talkId: 'talkId',
            ),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.mutate<FavoritesTalk>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<FavoritesTalk>>(),
              ),
            ),
          ).thenThrow(Exception('Error'));

          expect(
            () => dataSource.createFavoritesTalk(
              favoritesId: 'userId',
              talkId: 'talkId',
            ),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('deleteFavoritesTalk', () {
      setUp(() {
        when(
          () => apiClient.deleteById<FavoritesTalk>(
            FavoritesTalk.classType,
            any(),
          ),
        ).thenAnswer(
          (_) => GraphQLRequest<FavoritesTalk>(
            document: '',
          ),
        );
      });

      test('returns $FavoritesTalk when successful', () async {
        when(
          () => apiClient.mutate<FavoritesTalk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<FavoritesTalk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(TestHelpers.favoritesTalk),
        );

        final result = await dataSource.deleteFavoritesTalk(id: 'id');
        expect(result, isA<FavoritesTalk>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.mutate<FavoritesTalk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<FavoritesTalk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.favoritesTalk,
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.deleteFavoritesTalk(id: 'id'),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.mutate<FavoritesTalk>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<FavoritesTalk>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.deleteFavoritesTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.deleteById<FavoritesTalk>(
              FavoritesTalk.classType,
              any(),
            ),
          ).thenThrow(Exception('Error'));

          expect(
            () => dataSource.deleteFavoritesTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getFavorites', () {
      setUp(() {
        when(() => apiClient.list(Favorites.classType)).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Favorites>>(
            document: '',
          ),
        );
      });

      test('returns ${PaginatedResult<Favorites>} when successful', () async {
        when(
          () => apiClient.query<PaginatedResult<Favorites>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Favorites>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.favorites,
              Favorites.classType,
            ),
          ),
        );

        final result = await dataSource.getFavorites();
        expect(result, isA<PaginatedResult<Favorites>>());
      });

      test(
        'returns filtered ${PaginatedResult<Favorites>} when successful '
        'and [userId] is not null',
        () async {
          when(
            () => apiClient.list(
              Favorites.classType,
              where: any(
                named: 'where',
                that: isA<QueryPredicateOperation>()
                    .having((qpo) => qpo.field, 'Field', equals('userId')),
              ),
            ),
          ).thenAnswer(
            (_) => GraphQLRequest<PaginatedResult<Favorites>>(
              document: '',
            ),
          );
          when(
            () => apiClient.query<PaginatedResult<Favorites>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Favorites>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(
              TestHelpers.paginatedResult(
                TestHelpers.favorites,
                Favorites.classType,
              ),
            ),
          );

          final result = await dataSource.getFavorites(userId: 'userId');
          expect(
            result,
            isA<PaginatedResult<Favorites>>().having(
              (result) => result.items,
              'favorites',
              contains(TestHelpers.favorites),
            ),
          );
        },
      );

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<Favorites>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Favorites>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.favorites,
              Favorites.classType,
            ),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getFavorites(),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<Favorites>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Favorites>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getFavorites(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.list(Favorites.classType)).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getFavorites(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getLinks', () {
      setUp(() {
        when(
          () => apiClient.list(
            Link.classType,
            where: any(
              named: 'where',
              that: isA<QueryPredicateOperation>()
                  .having((qpo) => qpo.field, 'Field', equals('speaker')),
            ),
          ),
        ).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Link>>(
            document: '',
          ),
        );
      });

      test('returns ${PaginatedResult<Link>} when successful', () async {
        when(
          () => apiClient.query<PaginatedResult<Link>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Link>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.link, Link.classType),
          ),
        );

        final result = await dataSource.getLinks(speaker: TestHelpers.speaker);
        expect(result, isA<PaginatedResult<Link>>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<Link>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Link>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.link, Link.classType),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getLinks(speaker: TestHelpers.speaker),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<Link>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Link>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getLinks(speaker: TestHelpers.speaker),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.list(
              Link.classType,
              where: any(
                named: 'where',
                that: isA<QueryPredicateOperation>()
                    .having((qpo) => qpo.field, 'Field', equals('speaker')),
              ),
            ),
          ).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getLinks(speaker: TestHelpers.speaker),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getSpeakers', () {
      setUp(() {
        when(() => apiClient.list(Speaker.classType)).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Speaker>>(
            document: '',
          ),
        );
      });

      test('returns ${PaginatedResult<Speaker>} when successful', () async {
        when(
          () => apiClient.query<PaginatedResult<Speaker>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.speaker, Speaker.classType),
          ),
        );

        final result = await dataSource.getSpeakers();
        expect(result, isA<PaginatedResult<Speaker>>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<Speaker>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.speaker, Speaker.classType),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getSpeakers(),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<Speaker>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Speaker>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getSpeakers(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.list(Speaker.classType))
              .thenThrow(Exception('Error'));

          expect(
            () => dataSource.getSpeakers(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getSpeaker', () {
      setUp(() {
        when(() => apiClient.get<Speaker>(Speaker.classType, any())).thenAnswer(
          (_) => GraphQLRequest<Speaker>(
            document: '',
          ),
        );
      });

      test('returns $Speaker when successful', () async {
        when(
          () => apiClient.query<Speaker>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<Speaker>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(TestHelpers.speaker),
        );

        final result = await dataSource.getSpeaker(id: 'id');
        expect(result, isA<Speaker>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<Speaker>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<Speaker>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.speaker,
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getSpeaker(id: 'id'),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<Speaker>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<Speaker>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getSpeaker(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.get<Talk>(Talk.classType, any())).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getTalks', () {
      setUp(() {
        when(() => apiClient.list(Talk.classType)).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<Talk>>(
            document: '',
          ),
        );
      });
      test('returns ${PaginatedResult<Talk>} when successful', () async {
        when(
          () => apiClient.query<PaginatedResult<Talk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.talk, Talk.classType),
          ),
        );

        final result = await dataSource.getTalks();
        expect(result, isA<PaginatedResult<Talk>>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<Talk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(TestHelpers.talk, Talk.classType),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getTalks(),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<Talk>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<Talk>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getTalks(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.list(Talk.classType)).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getTalks(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getTalk', () {
      setUp(() {
        when(() => apiClient.get<Talk>(Talk.classType, any())).thenAnswer(
          (_) => GraphQLRequest<Talk>(
            document: '',
          ),
        );
      });

      test('returns $Talk when successful', () async {
        when(
          () => apiClient.query<Talk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<Talk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(TestHelpers.talk),
        );

        final result = await dataSource.getTalk(id: 'id');
        expect(result, isA<Talk>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<Talk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<Talk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.talk,
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getTalk(id: 'id'),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<Talk>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<Talk>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(() => apiClient.get<Talk>(Talk.classType, any())).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getFavoritesTalks', () {
      Matcher? isAFavoritesTalkQuery({bool hasTalk = false}) {
        final havingFavoritesAndTalks = isA<QueryPredicateOperation>()
            .having((qpo) => qpo.field, 'Field', equals('favorites'))
            .having((qpo) => qpo.field, 'Field', equals('talk'));

        final havingFavorites = isA<QueryPredicateOperation>()
            .having((qpo) => qpo.field, 'Field', equals('favorites'));

        return isA<QueryPredicateGroup>().having(
          (qpg) => qpg.predicates,
          'Predicates',
          contains(
            hasTalk ? havingFavoritesAndTalks : havingFavorites,
          ),
        );
      }

      setUp(() {
        when(
          () => apiClient.list(
            FavoritesTalk.classType,
            where: any(
              named: 'where',
              that: isAFavoritesTalkQuery(),
            ),
          ),
        ).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<FavoritesTalk>>(
            document: '',
          ),
        );
      });

      test('returns ${PaginatedResult<FavoritesTalk>} when successful',
          () async {
        when(
          () => apiClient.query<PaginatedResult<FavoritesTalk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<FavoritesTalk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.favoritesTalk,
              FavoritesTalk.classType,
            ),
          ),
        );

        final result = await dataSource.getFavoritesTalks(favoritesId: 'id');
        expect(result, isA<PaginatedResult<FavoritesTalk>>());
      });

      test(
          'returns ${PaginatedResult<FavoritesTalk>} filtered by talk '
          'when successful', () async {
        when(
          () => apiClient.list(
            FavoritesTalk.classType,
            where: any(
              named: 'where',
              that: isAFavoritesTalkQuery(hasTalk: true),
            ),
          ),
        ).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<FavoritesTalk>>(document: ''),
        );
        when(
          () => apiClient.query<PaginatedResult<FavoritesTalk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<FavoritesTalk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.favoritesTalk,
              FavoritesTalk.classType,
            ),
          ),
        );

        final result = await dataSource.getFavoritesTalks(
          favoritesId: 'id',
          talkId: 'talkId',
        );
        expect(result, isA<PaginatedResult<FavoritesTalk>>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<FavoritesTalk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<FavoritesTalk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.favoritesTalk,
              FavoritesTalk.classType,
            ),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getFavoritesTalks(favoritesId: 'id'),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<FavoritesTalk>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<FavoritesTalk>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getFavoritesTalks(favoritesId: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.list(
              FavoritesTalk.classType,
              where: any(
                named: 'where',
                that: isAFavoritesTalkQuery(),
              ),
            ),
          ).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getFavoritesTalks(favoritesId: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getFavoritesTalk', () {
      setUp(() {
        when(() => apiClient.get<FavoritesTalk>(FavoritesTalk.classType, any()))
            .thenAnswer(
          (_) => GraphQLRequest<FavoritesTalk>(
            document: '',
          ),
        );
      });

      test('returns $FavoritesTalk when successful', () async {
        when(
          () => apiClient.query<FavoritesTalk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<FavoritesTalk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(TestHelpers.favoritesTalk),
        );

        final result = await dataSource.getFavoritesTalk(id: 'id');
        expect(result, isA<FavoritesTalk>());
      });

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<FavoritesTalk>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<FavoritesTalk>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.favoritesTalk,
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getFavoritesTalk(id: 'id'),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<FavoritesTalk>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<FavoritesTalk>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getFavoritesTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.get<FavoritesTalk>(FavoritesTalk.classType, any()),
          ).thenThrow(Exception('Error'));

          expect(
            () => dataSource.getFavoritesTalk(id: 'id'),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });

    group('getSpeakerTalks', () {
      setUp(() {
        when(
          () => apiClient.list(
            SpeakerTalk.classType,
            where: any(named: 'where', that: isA<QueryPredicateGroup>()),
          ),
        ).thenAnswer(
          (_) => GraphQLRequest<PaginatedResult<SpeakerTalk>>(
            document: '',
          ),
        );
      });

      test(
        'returns ${PaginatedResult<SpeakerTalk>} when successful',
        () async {
          when(
            () => apiClient.query<PaginatedResult<SpeakerTalk>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<SpeakerTalk>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(
              TestHelpers.paginatedResult(
                TestHelpers.speakerTalk,
                SpeakerTalk.classType,
              ),
            ),
          );

          final result = await dataSource.getSpeakerTalks();
          expect(result, isA<PaginatedResult<SpeakerTalk>>());
        },
      );

      test('throws $AmplifyApiException when response has errors', () async {
        when(
          () => apiClient.query<PaginatedResult<SpeakerTalk>>(
            request: any(
              named: 'request',
              that: isA<GraphQLRequest<PaginatedResult<SpeakerTalk>>>(),
            ),
          ),
        ).thenReturn(
          TestHelpers.graphQLOperation(
            TestHelpers.paginatedResult(
              TestHelpers.speakerTalk,
              SpeakerTalk.classType,
            ),
            errors: [GraphQLResponseError(message: 'Error')],
          ),
        );

        expect(
          () => dataSource.getSpeakerTalks(),
          throwsA(isA<AmplifyApiException>()),
        );
      });

      test(
        'throws $AmplifyApiException when response data is null',
        () async {
          when(
            () => apiClient.query<PaginatedResult<SpeakerTalk>>(
              request: any(
                named: 'request',
                that: isA<GraphQLRequest<PaginatedResult<SpeakerTalk>>>(),
              ),
            ),
          ).thenReturn(
            TestHelpers.graphQLOperation(null),
          );

          expect(
            () => dataSource.getSpeakerTalks(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );

      test(
        'throws $AmplifyApiException when an exception is thrown',
        () async {
          when(
            () => apiClient.list(
              SpeakerTalk.classType,
              where: any(named: 'where', that: isA<QueryPredicateGroup>()),
            ),
          ).thenThrow(
            Exception('Error'),
          );

          expect(
            () => dataSource.getSpeakerTalks(),
            throwsA(isA<AmplifyApiException>()),
          );
        },
      );
    });
  });
}
