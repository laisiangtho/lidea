part of 'main.dart';

class RouteParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async {
    // debugPrint('parse: ${routeInformation.location}');

    // return Uri.parse(routeInformation.location!);
    return routeInformation.uri;
  }

  @override
  RouteInformation restoreRouteInformation(Uri configuration) {
    // debugPrint('restore: ${configuration.path}');
    String uri = configuration.path;
    final param = configuration.queryParameters;
    // debugPrint('restore-isNotEmpty: ${param.isNotEmpty}');
    if (param.isNotEmpty) {
      String queryString = Uri(queryParameters: param).query;
      uri = '$uri?$queryString';
    }

    // return RouteInformation(uri: Uri.parse(routeInformation.location!));
    return RouteInformation(uri: Uri.parse(uri));
  }
}
