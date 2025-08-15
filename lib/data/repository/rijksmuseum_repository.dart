import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:injectable/injectable.dart';

import '../source/rijksmuseum_api/rijksmuseum_api_source.dart';

@injectable
class RijksmuseumRepository {
  RijksmuseumRepository(this._source);

  final RijksmuseumApiSource _source;

  Future<List<ArtObject>> getArtObjectCollection() => _source.getArtObjectCollection();
}
