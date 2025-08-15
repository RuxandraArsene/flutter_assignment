
import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/data/repository/rijksmuseum_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArtObjectCollectionUseCase {
  GetArtObjectCollectionUseCase(this._repository);

  final RijksmuseumRepository _repository;

  Future<List<ArtObject>> execute() => _repository.getArtObjectCollection();
}