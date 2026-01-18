sealed class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.title,
    required this.message,
    this.details,
  });

  final String code;
  final String title;
  final String message;
  final String? details;

  @override
  String toString() => 'ApiException($code): $title - $message';
}

final class NetworkException extends ApiException {
  const NetworkException({super.details})
      : super(
    code: 'NETWORK_ERROR',
    title: 'Connection problem',
    message: 'Unable to reach the server. Check your connection and try again.',
  );
}

final class RequestTimeoutException extends ApiException {
  const RequestTimeoutException({super.details})
      : super(
    code: 'TIMEOUT',
    title: 'Request timed out',
    message: 'The server took too long to respond. Please try again.',
  );
}

final class HttpStatusException extends ApiException {
  const HttpStatusException({
    required int statusCode,
    String? responseBody,
  }) : super(
    code: 'HTTP_$statusCode',
    title: 'Server error',
    message: 'Server returned status code $statusCode.',
    details: responseBody,
  );
}

final class DataFormatException extends ApiException {
  const DataFormatException({super.details})
      : super(
    code: 'BAD_RESPONSE_FORMAT',
    title: 'Invalid server response',
    message: 'The server returned data in an unexpected format.',
  );
}

final class UnknownApiException extends ApiException {
  const UnknownApiException({super.details})
      : super(
    code: 'UNKNOWN',
    title: 'Unexpected error',
    message: 'An unexpected error happened. Please try again.',
  );
}
