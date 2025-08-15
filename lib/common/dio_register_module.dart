import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioRegisterModule {
  @factoryMethod
  Dio get dio => Dio();
}
