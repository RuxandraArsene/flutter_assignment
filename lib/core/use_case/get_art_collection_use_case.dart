
import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/data/repository/collection_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArtCollectionUseCase {
  GetArtCollectionUseCase(this._repository);

  final CollectionRepository _repository;

  Future<List<ArtObject>> execute() async => _repository.getArtCollection();
}