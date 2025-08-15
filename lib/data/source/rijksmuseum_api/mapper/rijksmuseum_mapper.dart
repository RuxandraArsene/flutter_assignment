import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/dto/get_collection_response_dto.dart';
import 'package:injectable/injectable.dart';

@injectable
class RijksmuseumMapper {
  List<ArtObject> mapArtObject(GetCollectionResponse responseDto) {
    final artObjects = responseDto.artObjects
        .map(
          (object) => ArtObject(
            objectNumber: object.objectNumber,
            title: object.title,
            longTitle: object.longTitle,
            principalOrFirstMaker: object.principalOrFirstMaker,
            headerImageUrl: _mapHeaderImage(object.headerImage),
            productionPlaces: object.productionPlaces,
          ),
        )
        .toList();

    return artObjects;
  }

  String _mapHeaderImage(HeaderImageDto dto) => dto.url;
}
