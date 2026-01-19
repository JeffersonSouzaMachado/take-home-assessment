import 'package:pulsenow_flutter/utils/constants.dart';

Uri buildUri(String path, {Map<String, String>? queryParameters}) {
  final base = Uri.parse(AppConstants.baseServerUrl);

  return Uri(
    scheme: base.scheme,
    host: base.host,
    port: base.hasPort ? base.port : null,
    path: '${base.path}$path', // base.path = /api
    queryParameters: queryParameters,
  );
}
