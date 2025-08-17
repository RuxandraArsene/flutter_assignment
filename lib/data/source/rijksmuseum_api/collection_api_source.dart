import 'package:dio/dio.dart';
import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/data/source/common/base_api_source.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/mapper/collection_mapper.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/rijksmuseum_api_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class CollectionApiSource extends BaseApiSource {
  CollectionApiSource(this._client, this._collectionMapper);

  final Client _client;
  final CollectionMapper _collectionMapper;
  static const testApiKey = '0fiuZFh4';

  Future<List<ArtObject>> getArtCollection() async {
    try {
      final response = await _client.getCollection(key: testApiKey);

      final List<ArtObject> result = _collectionMapper.mapArtObject(response);

      return result;
    } on DioException catch (e) {
      return handleError(e);
    }
  }
}