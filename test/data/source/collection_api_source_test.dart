import 'package:dio/dio.dart';
import 'package:flutter_assignment/core/error/custom_error.dart';
import 'package:flutter_assignment/core/model/art_object.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/collection_api_source.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/dto/get_collection_response_dto.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/mapper/collection_mapper.dart';
import 'package:flutter_assignment/data/source/rijksmuseum_api/rijksmuseum_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'collection_api_source_test.mocks.dart';

@GenerateMocks([Client, GetCollectionResponse, CollectionMapper])
void main() {
  final Client client = MockClient();
  final GetCollectionResponse response = MockGetCollectionResponse();
  final CollectionMapper mapper = MockCollectionMapper();

  final CollectionApiSource source = CollectionApiSource(client, mapper);

  group('getArtCollection', () {
    test('returns mapped art objects on successful response', () async {
      final List<ArtObject> artObjects = List.generate(
        2,
        (i) => ArtObject(
          objectNumber: 'SK-A-${i + 1}',
          title: 'Art object ${i + 1}',
          principalOrFirstMaker: 'Artist ${i + 1}',
          longTitle: 'Long Title ${i + 1}',
          imageUrl: 'https://example.com/image/${i + 1}.png',
          productionPlaces: ['Place ${i + 1}'],
        ),
      );
      when(
        client.getCollection(key: CollectionApiSource.testApiKey),
      ).thenAnswer((_) async => response);

      when(mapper.mapArtObject(response)).thenReturn(artObjects);

      final result = await source.getArtCollection();

      expect(result, artObjects);
      verify(
        client.getCollection(key: CollectionApiSource.testApiKey),
      ).called(1);
      verify(mapper.mapArtObject(response)).called(1);
    });

    test('handles DioException and returns result from handleError', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
        ),
      );

      when(
        client.getCollection(key: CollectionApiSource.testApiKey),
      ).thenThrow(dioException);

      expect(source.getArtCollection(), throwsA(isA<UnauthorizedError>()));
      verify(
        client.getCollection(key: CollectionApiSource.testApiKey),
      ).called(1);
      verifyNever(mapper.mapArtObject(response));
    });
  });
}
