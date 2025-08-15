import 'package:json_annotation/json_annotation.dart';

part 'get_collection_response_dto.g.dart';

@JsonSerializable()
class GetCollectionResponse {
  GetCollectionResponse(this.artObjects);

  factory GetCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCollectionResponseToJson(this);

  final List<ArtObjectDto> artObjects;
}

@JsonSerializable()
class ArtObjectDto {
  ArtObjectDto(
      this.objectNumber,
      this.title,
      this.principalOrFirstMaker,
      this.longTitle,
      this.headerImage,
      this.productionPlaces,
      );

  factory ArtObjectDto.fromJson(Map<String, dynamic> json) =>
      _$ArtObjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArtObjectDtoToJson(this);


  final String objectNumber;
  final String title;
  final String principalOrFirstMaker;
  final String longTitle;
  final HeaderImageDto headerImage;
  final List<String> productionPlaces;
}

@JsonSerializable()
class HeaderImageDto {
  HeaderImageDto(this.url);

  factory HeaderImageDto.fromJson(Map<String, dynamic> json) =>
      _$HeaderImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderImageDtoToJson(this);

  final String url;
}


