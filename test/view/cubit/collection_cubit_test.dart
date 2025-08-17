import 'package:flutter_assignment/core/error/custom_error.dart';
import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/core/use_case/get_art_collection_use_case.dart';
import 'package:flutter_assignment/view/cubit/collection/collection_cubit.dart';
import 'package:flutter_assignment/view/cubit/collection/collection_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'collection_cubit_test.mocks.dart';

@GenerateMocks([GetArtCollectionUseCase])
void main() {
  final GetArtCollectionUseCase getArtCollectionUseCase =
      MockGetArtCollectionUseCase();

  final CollectionCubit cubit = CollectionCubit(getArtCollectionUseCase);
  final List<ArtObject> artObjects = List.generate(
    5,
    (i) => ArtObject(
      objectNumber: 'SK-A-${i + 1}',
      title: 'Art object ${i + 1}',
      principalOrFirstMaker: 'Artist ${i + 1}',
      longTitle: 'Long Title ${i + 1}',
      imageUrl: 'https://example.com/image/${i + 1}.png',
      productionPlaces: ['Place ${i + 1}'],
    ),
  );

  group('getArtCollection', () {
    test(
      'emits loading and retrieved state with grouped data and more pages available',
      () async {
        when(
          getArtCollectionUseCase.execute(),
        ).thenAnswer((_) async => artObjects);

        final expectedStates = [
          isA<CollectionLoadingState>(),
          isA<CollectionRetrievedState>()
              .having(
                (state) => state.isLoadingMoreData,
                'isLoadingMoreData',
                false,
              )
              .having(
                (state) => state.hasMoreGroupsToLoad,
                'hasMoreGroupsToLoad',
                true,
              )
              .having(
                (state) => state.groupedArtObjects.isNotEmpty,
                'groupedArtObjects.isNotEmpty',
                true,
              ),
        ];
        final expectedState = expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        await cubit.getArtCollection();
        await expectedState;
      },
    );

    test(
      'emits loading and retrieved state with empty data and no more pages available',
      () async {
        when(getArtCollectionUseCase.execute()).thenAnswer((_) async => []);

        final expectedStates = [
          isA<CollectionLoadingState>(),
          isA<CollectionRetrievedState>()
              .having(
                (state) => state.isLoadingMoreData,
                'isLoadingMoreData',
                false,
              )
              .having(
                (state) => state.hasMoreGroupsToLoad,
                'hasMoreGroupsToLoad',
                false,
              )
              .having(
                (state) => state.groupedArtObjects.isEmpty,
                'groupedArtObjects.isEmpty',
                true,
              ),
        ];
        final emittedStates = expectLater(
          cubit.stream,
          emitsInOrder(expectedStates),
        );

        await cubit.getArtCollection();
        await emittedStates;
      },
    );

    test(
      'resets page to 1 and emits retrieved state when getArtCollection is called again',
      () async {
        when(
          getArtCollectionUseCase.execute(),
        ).thenAnswer((_) async => artObjects);

        await cubit.getArtCollection();
        if ((cubit.state as CollectionRetrievedState).hasMoreGroupsToLoad) {
          await cubit.loadMoreGroups();
          expect(cubit.page, 2);
        }

        await cubit.getArtCollection();
        expect(cubit.page, 1);
        expect(cubit.state, isA<CollectionRetrievedState>());
      },
    );

    test(
      'emits error state with proper message when NoDataConnectionError is thrown',
      () async {
        when(
          getArtCollectionUseCase.execute(),
        ).thenThrow(NoDataConnectionError());

        await cubit.getArtCollection();

        expect(cubit.state, isA<CollectionErrorState>());
        expect(
          (cubit.state as CollectionErrorState).errorMessage,
          'No internet connection. Please check your network.',
        );
      },
    );

    test(
      'emits error state with proper message when UnauthorizedError is thrown',
      () async {
        when(getArtCollectionUseCase.execute()).thenThrow(UnauthorizedError());

        await cubit.getArtCollection();

        expect(cubit.state, isA<CollectionErrorState>());
        expect(
          (cubit.state as CollectionErrorState).errorMessage,
          'You are not authorized to access this resource.',
        );
      },
    );

    test(
      'emits error state with generic message when Exception is thrown',
      () async {
        when(getArtCollectionUseCase.execute()).thenThrow(Exception());
        await cubit.getArtCollection();

        expect(cubit.state, isA<CollectionErrorState>());
        expect(
          (cubit.state as CollectionErrorState).errorMessage,
          'Something went wrong',
        );
      },
    );
  });

  group('loadMoreGroups', () {
    test(
      'increments page and emits retrieved state when loading the last page of items',
      () async {
        when(
          getArtCollectionUseCase.execute(),
        ).thenAnswer((_) async => artObjects);

        await cubit.getArtCollection();
        final initialState = cubit.state as CollectionRetrievedState;
        expect(initialState.hasMoreGroupsToLoad, true);
        expect(cubit.page, 1);

        final expectedStates = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<CollectionRetrievedState>()
                .having((s) => s.isLoadingMoreData, 'isLoadingMoreData', true)
                .having(
                  (s) => s.hasMoreGroupsToLoad,
                  'hasMoreGroupsToLoad',
                  false,
                )
                .having(
                  (s) =>
                      s.groupedArtObjects.values.expand((list) => list).length,
                  'total items',
                  artObjects.length,
                ),
          ]),
        );

        await cubit.loadMoreGroups();

        await expectedStates;
        expect(cubit.page, 2);
        final finalState = cubit.state as CollectionRetrievedState;
        expect(finalState.isLoadingMoreData, true);
        expect(finalState.hasMoreGroupsToLoad, false);
        expect(
          finalState.groupedArtObjects.values.expand((list) => list).length,
          artObjects.length,
        );
      },
    );
  });

  test(
    'does not emit new states and page does not increment if hasMoreGroupsToLoad is false',
    () async {
      final fewArtObjects = artObjects.sublist(0, 2);
      when(
        getArtCollectionUseCase.execute(),
      ).thenAnswer((_) async => fewArtObjects);

      await cubit.getArtCollection();
      expect(cubit.page, 1);
      expect(
        (cubit.state as CollectionRetrievedState).hasMoreGroupsToLoad,
        false,
      );

      await cubit.loadMoreGroups();

      expect(cubit.state, same(cubit.state));
      expect(cubit.page, 1);
    },
  );
}
