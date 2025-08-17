abstract class CustomError implements Exception {}

class DefaultError implements CustomError {
  DefaultError({this.content});

  final String? content;
}

class NoDataConnectionError implements CustomError {}

class NotFoundError implements CustomError {}

class UnauthorizedError implements CustomError {}

class TimeoutError implements CustomError {}

class ServerError implements CustomError {}
