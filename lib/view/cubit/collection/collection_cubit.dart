import 'package:flutter_assignment/view/common/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/model/art_object.dart';
import '../../../core/use_case/get_art_object_collection_use_case.dart';
import 'collection_state.dart';

@injectable
class CollectionCubit extends Cubit<BaseState> {
  CollectionCubit(this._getArtObjectCollectionUseCase) : super(InitialState());

  final GetArtObjectCollectionUseCase _getArtObjectCollectionUseCase;

  Future<void> getArtCollection() async {
    emit(CollectionLoadingState());
    try {
      final collection = await _getArtObjectCollectionUseCase.execute();
      final groupedObjects = _groupArtObjects(collection);
      List<String> sortedObjects = _sortArtObjectsByKeys(groupedObjects);

      emit(
        CollectionRetrievedState(
          groupedArtObjects: groupedObjects,
          sortedGroupedObjectByKeys: sortedObjects,
        ),
      );
    } catch (e) {
      emit(CollectionErrorState(errorMessage: e.toString()));
    }
  }

  Map<String, List<ArtObject>> _groupArtObjects(List<ArtObject> collection) {
    final Map<String, List<ArtObject>> groupedObjects = {};

    for (var artObject in collection) {
      final key = artObject.title.isNotEmpty
          ? artObject.title[0].toUpperCase()
          : "#";

      groupedObjects.putIfAbsent(key, () => []).add(artObject);
    }

    return groupedObjects;
  }

  List<String> _sortArtObjectsByKeys(
    Map<String, List<ArtObject>> groupedObjects,
  ) {
    final sortedObjects = groupedObjects.keys.toList();
    sortedObjects.sort((a, b) => a.compareTo(b));
    return sortedObjects;
  }
}
