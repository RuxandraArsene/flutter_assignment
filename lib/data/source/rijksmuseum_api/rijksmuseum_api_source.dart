
import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/mapper/rijksmuseum_mapper.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/rijksmuseum_api_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class RijksmuseumApiSource {
  RijksmuseumApiSource(this._client, this._rijksmuseumMapper);

  final Client _client;
  final RijksmuseumMapper _rijksmuseumMapper;

  Future<List<ArtObject>> getArtObjectCollection() async {
    final response = await _client.getCollection();

    final List<ArtObject> result = _rijksmuseumMapper.mapArtObject(response);

    return result;
  }
}