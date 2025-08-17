// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_collection_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCollectionResponse _$GetCollectionResponseFromJson(
  Map<String, dynamic> json,
) => GetCollectionResponse(
  (json['artObjects'] as List<dynamic>)
      .map((e) => ArtObjectDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetCollectionResponseToJson(
  GetCollectionResponse instance,
) => <String, dynamic>{'artObjects': instance.artObjects};

ArtObjectDto _$ArtObjectDtoFromJson(Map<String, dynamic> json) => ArtObjectDto(
  json['objectNumber'] as String,
  json['title'] as String,
  json['principalOrFirstMaker'] as String,
  json['longTitle'] as String,
  WebImageDto.fromJson(json['webImage'] as Map<String, dynamic>),
  (json['productionPlaces'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ArtObjectDtoToJson(ArtObjectDto instance) =>
    <String, dynamic>{
      'objectNumber': instance.objectNumber,
      'title': instance.title,
      'principalOrFirstMaker': instance.principalOrFirstMaker,
      'longTitle': instance.longTitle,
      'webImage': instance.webImage,
      'productionPlaces': instance.productionPlaces,
    };

WebImageDto _$WebImageDtoFromJson(Map<String, dynamic> json) =>
    WebImageDto(json['url'] as String);

Map<String, dynamic> _$WebImageDtoToJson(WebImageDto instance) =>
    <String, dynamic>{'url': instance.url};
