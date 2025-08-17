import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/view/common/base_state.dart';

class CollectionLoadingState extends BaseState {}

class CollectionErrorState extends BaseState {
  CollectionErrorState({required this.errorMessage});

  final String errorMessage;
}

class CollectionRetrievedState extends BaseState {
  CollectionRetrievedState({
    required this.groupedArtObjects,
    required this.sortedGroupedObjectByKeys,
    required this.isLoadingMoreData,
    required this.hasMoreGroupsToLoad,
  });

  final Map<String, List<ArtObject>> groupedArtObjects;
  final List<String> sortedGroupedObjectByKeys;
  final bool isLoadingMoreData;
  final bool hasMoreGroupsToLoad;

  List<Object?> get props => [groupedArtObjects, sortedGroupedObjectByKeys];
}
