import 'package:flutter_assignment/view/common/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/custom_error.dart';
import '../../../core/model/art_object.dart';
import '../../../core/use_case/get_art_collection_use_case.dart';
import 'collection_state.dart';

@injectable
class CollectionCubit extends Cubit<BaseState> {
  CollectionCubit(this._getArtObjectCollectionUseCase) : super(InitialState());

  final GetArtCollectionUseCase _getArtObjectCollectionUseCase;

  final int _limit = 3;
  int _page = 1;
  bool _hasMoreGroupsToLoad = false;
  List<ArtObject> _artObjects = [];

  int get page => _page;

  bool get hasMoreGroupsToLoad => _hasMoreGroupsToLoad;

  List<ArtObject> get artObjects => _artObjects;

  Future<void> getArtCollection() async {
    emit(CollectionLoadingState());
    try {
      _artObjects = await _getArtObjectCollectionUseCase.execute();
      _hasMoreGroupsToLoad = true;
      _page = 1;

      _emitState();
    } catch (e) {
      String errorMessage;

      if (e is NoDataConnectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e is UnauthorizedError) {
        errorMessage = 'You are not authorized to access this resource.';
      } else {
        errorMessage = 'Something went wrong';
      }

      emit(CollectionErrorState(errorMessage: errorMessage));
    }
  }

  Future<void> loadMoreGroups() async {
    if (!_hasMoreGroupsToLoad) return;

    _page++;
    _emitState(isLoadingMoreData: true);
  }

  void _emitState({bool isLoadingMoreData = false}) {
    Map<String, List<ArtObject>> grouped = _getGroupedObjectsForCurrentPage();

    emit(
      CollectionRetrievedState(
        groupedArtObjects: grouped,
        sortedGroupedObjectByKeys: _sortArtObjectsByKeys(grouped),
        isLoadingMoreData: isLoadingMoreData,
        hasMoreGroupsToLoad: _hasMoreGroupsToLoad,
      ),
    );
  }

  Map<String, List<ArtObject>> _getGroupedObjectsForCurrentPage() {
    int endIndex = _page * _limit;
    if (endIndex >= _artObjects.length) {
      endIndex = _artObjects.length;
      _hasMoreGroupsToLoad = false;
    }

    final currentObjects = _artObjects.sublist(0, endIndex);

    return _groupArtObjects(currentObjects);
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
