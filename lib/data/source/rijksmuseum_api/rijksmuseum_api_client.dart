import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'dto/get_collection_response_dto.dart';

part 'rijksmuseum_api_client.g.dart';

@RestApi(baseUrl: 'https://www.rijksmuseum.nl/api/en/')
@injectable
abstract class Client {
  @factoryMethod
  factory Client(Dio dio) {
    dio.options.headers['Content-Type'] = 'application/json';

    return _Client(dio);
  }

  @GET('collection?key=0fiuZFh4')
  Future<GetCollectionResponse> getCollection();
}
