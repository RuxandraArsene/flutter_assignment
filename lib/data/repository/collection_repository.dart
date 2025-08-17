import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:injectable/injectable.dart';

import '../source/rijksmuseum_api/collection_api_source.dart';

@injectable
class CollectionRepository {
  CollectionRepository(this._source);

  final CollectionApiSource _source;

  Future<List<ArtObject>> getArtCollection() async =>
      await _source.getArtCollection();
}
