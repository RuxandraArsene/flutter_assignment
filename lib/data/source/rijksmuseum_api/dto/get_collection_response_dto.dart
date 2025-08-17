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
      this.webImage,
      this.productionPlaces,
      );

  factory ArtObjectDto.fromJson(Map<String, dynamic> json) =>
      _$ArtObjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArtObjectDtoToJson(this);


  final String objectNumber;
  final String title;
  final String principalOrFirstMaker;
  final String longTitle;
  final WebImageDto webImage;
  final List<String> productionPlaces;
}

@JsonSerializable()
class WebImageDto {
  WebImageDto(this.url);

  factory WebImageDto.fromJson(Map<String, dynamic> json) =>
      _$WebImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WebImageDtoToJson(this);

  final String url;
}


