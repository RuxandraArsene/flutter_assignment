import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/error/custom_error.dart';

abstract class BaseApiSource {
  Future<T> handleError<T>(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.message;
    final data = error.response?.data.toString();

    if (error.error is SocketException) {
      return Future.error(NoDataConnectionError());
    }

    if (statusCode != null) {
      switch (statusCode) {
        case 401:
          return Future.error(UnauthorizedError());
        case 404:
          return Future.error(NotFoundError());
        case 500:
          return Future.error(ServerError());
        default:
          return Future.error(DefaultError(content: data));
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Future.error(TimeoutError());
      case DioExceptionType.badResponse:
        return Future.error(ServerError());
      case DioExceptionType.cancel:
        return Future.error(DefaultError(content: data));
      case DioExceptionType.unknown:
      default:
        return Future.error(DefaultError(content: message));
    }
  }
}
